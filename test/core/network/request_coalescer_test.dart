import 'dart:async';
import 'dart:convert';

import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/request_coalescer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

/// Client di prova che tiene una risposta in sospeso finché il test non la
/// rilascia, e conta quante richieste ha ricevuto.
class _PendingClient extends http.BaseClient {
  final List<Uri> requests = <Uri>[];
  final Map<String, Completer<String>> _pending = <String, Completer<String>>{};

  int get callCount => requests.length;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add(request.url);
    final completer = _pending.putIfAbsent(
      request.url.path,
      Completer<String>.new,
    );
    final body = await completer.future;
    return http.StreamedResponse(
      Stream<List<int>>.value(utf8.encode(body)),
      200,
      request: request,
    );
  }

  void complete(String path, String body) {
    _pending.putIfAbsent(path, Completer<String>.new).complete(body);
    _pending.remove(path);
  }
}

void main() {
  group('RequestCoalescer', () {
    test('la chiave ignora l ordine dei parametri di query', () {
      expect(
        RequestCoalescer.keyFor('GET', '/exercises', {'b': '2', 'a': '1'}),
        RequestCoalescer.keyFor('get', '/exercises', {'a': '1', 'b': '2'}),
      );
    });

    test('la voce si rimuove al completamento', () async {
      final coalescer = RequestCoalescer();
      final completer = Completer<int>();
      final future = coalescer.run<int>('k', () => completer.future);

      expect(coalescer.inFlightCount, 1);
      completer.complete(1);
      await future;
      expect(coalescer.inFlightCount, 0);
    });

    test('un fallimento non lascia la voce in volo', () async {
      final coalescer = RequestCoalescer();
      await expectLater(
        coalescer.run<int>('k', () => Future<int>.error(StateError('x'))),
        throwsStateError,
      );
      expect(coalescer.inFlightCount, 0);
    });
  });

  group('ApiClient.get coalescing', () {
    late _PendingClient client;
    late ApiClient api;

    setUp(() {
      client = _PendingClient();
      api = ApiClient(client: client, baseUrl: 'https://coachly.test/api');
    });

    test(
      'due GET concorrenti sullo stesso path fanno una sola richiesta',
      () async {
        final first = api.get<Map<String, dynamic>>(
          '/exercises/1',
          fromJson: (json) => json as Map<String, dynamic>,
        );
        final second = api.get<Map<String, dynamic>>(
          '/exercises/1',
          fromJson: (json) => json as Map<String, dynamic>,
        );

        await Future<void>.delayed(Duration.zero);
        client.complete('/api/exercises/1', '{"id":"1"}');

        final results = await Future.wait([first, second]);
        expect(client.callCount, 1);
        expect(results.every((r) => r.success), isTrue);
        expect(results.map((r) => r.data?['id']), everyElement('1'));
      },
    );

    test('due GET su path diversi fanno due richieste', () async {
      final first = api.get<Map<String, dynamic>>(
        '/exercises/1',
        fromJson: (json) => json as Map<String, dynamic>,
      );
      final second = api.get<Map<String, dynamic>>(
        '/exercises/2',
        fromJson: (json) => json as Map<String, dynamic>,
      );

      await Future<void>.delayed(Duration.zero);
      client.complete('/api/exercises/1', '{"id":"1"}');
      client.complete('/api/exercises/2', '{"id":"2"}');

      await Future.wait([first, second]);
      expect(client.callCount, 2);
    });

    test('dopo il completamento una nuova richiesta riparte', () async {
      final first = api.get<Map<String, dynamic>>(
        '/exercises/1',
        fromJson: (json) => json as Map<String, dynamic>,
      );
      await Future<void>.delayed(Duration.zero);
      client.complete('/api/exercises/1', '{"id":"1"}');
      await first;

      final second = api.get<Map<String, dynamic>>(
        '/exercises/1',
        fromJson: (json) => json as Map<String, dynamic>,
      );
      await Future<void>.delayed(Duration.zero);
      client.complete('/api/exercises/1', '{"id":"1"}');
      await second;

      expect(client.callCount, 2);
    });
  });

  group('CancelToken', () {
    test('una richiesta cancellata non emette il risultato', () async {
      final client = _PendingClient();
      final api = ApiClient(
        client: client,
        baseUrl: 'https://coachly.test/api',
      );
      final token = CancelToken();

      final future = api.get<Map<String, dynamic>>(
        '/exercises/1',
        fromJson: (json) => json as Map<String, dynamic>,
        cancelToken: token,
      );

      await Future<void>.delayed(Duration.zero);
      token.cancel();

      final response = await future;
      expect(ApiClient.wasCancelled(response), isTrue);
      expect(response.data, isNull);

      // La risposta tardiva non deve riaprire nulla.
      client.complete('/api/exercises/1', '{"id":"1"}');
      await Future<void>.delayed(Duration.zero);
    });

    test('un token gia cancellato non parte con una risposta', () async {
      final client = _PendingClient();
      final api = ApiClient(
        client: client,
        baseUrl: 'https://coachly.test/api',
      );
      final token = CancelToken()..cancel();

      final response = await api.get<Map<String, dynamic>>(
        '/exercises/1',
        fromJson: (json) => json as Map<String, dynamic>,
        cancelToken: token,
      );

      expect(ApiClient.wasCancelled(response), isTrue);
      client.complete('/api/exercises/1', '{"id":"1"}');
    });

    test(
      'una cancellazione dopo la cancellazione libera il coalescer',
      () async {
        final client = _PendingClient();
        final api = ApiClient(
          client: client,
          baseUrl: 'https://coachly.test/api',
        );
        final token = CancelToken();

        final cancelled = api.get<Map<String, dynamic>>(
          '/exercises/1',
          fromJson: (json) => json as Map<String, dynamic>,
          cancelToken: token,
        );
        await Future<void>.delayed(Duration.zero);
        token.cancel();
        await cancelled;

        final retry = api.get<Map<String, dynamic>>(
          '/exercises/1',
          fromJson: (json) => json as Map<String, dynamic>,
        );
        await Future<void>.delayed(Duration.zero);
        client.complete('/api/exercises/1', '{"id":"1"}');
        final response = await retry;

        expect(response.success, isTrue);
        expect(client.callCount, 2);
      },
    );
  });
}
