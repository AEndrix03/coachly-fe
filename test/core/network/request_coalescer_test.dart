import 'dart:async';

import 'package:coachly/core/network/api_client.dart';
import 'package:coachly/core/network/request_coalescer.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_dio.dart';

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
    late FakeDioAdapter client;
    late ApiClient api;

    setUp(() {
      client = FakeDioAdapter()..holdRequests = true;
      api = ApiClient(
        dio: fakeDio(client),
        baseUrl: 'https://coachly.test/api',
      );
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

        await pumpEventQueue();
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

      await pumpEventQueue();
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
      await pumpEventQueue();
      client.complete('/api/exercises/1', '{"id":"1"}');
      await first;

      final second = api.get<Map<String, dynamic>>(
        '/exercises/1',
        fromJson: (json) => json as Map<String, dynamic>,
      );
      await pumpEventQueue();
      client.complete('/api/exercises/1', '{"id":"1"}');
      await second;

      expect(client.callCount, 2);
    });
  });

  group('CancelToken', () {
    test('una richiesta cancellata non emette il risultato', () async {
      final client = FakeDioAdapter()..holdRequests = true;
      final api = ApiClient(
        dio: fakeDio(client),
        baseUrl: 'https://coachly.test/api',
      );
      final token = CancelToken();

      final future = api.get<Map<String, dynamic>>(
        '/exercises/1',
        fromJson: (json) => json as Map<String, dynamic>,
        cancelToken: token,
      );

      await pumpEventQueue();
      token.cancel();

      final response = await future;
      expect(ApiClient.wasCancelled(response), isTrue);
      expect(response.data, isNull);

      // La risposta tardiva non deve riaprire nulla.
      client.complete('/api/exercises/1', '{"id":"1"}');
      await pumpEventQueue();
    });

    test('un token gia cancellato non parte con una risposta', () async {
      final client = FakeDioAdapter()..holdRequests = true;
      final api = ApiClient(
        dio: fakeDio(client),
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
        final client = FakeDioAdapter()..holdRequests = true;
        final api = ApiClient(
          dio: fakeDio(client),
          baseUrl: 'https://coachly.test/api',
        );
        final token = CancelToken();

        final cancelled = api.get<Map<String, dynamic>>(
          '/exercises/1',
          fromJson: (json) => json as Map<String, dynamic>,
          cancelToken: token,
        );
        await pumpEventQueue();
        // La richiesta deve essere davvero partita: cancellarla prima che
        // arrivi all'adapter verificherebbe un caso diverso.
        expect(client.callCount, 1);
        token.cancel();
        await cancelled;

        final retry = api.get<Map<String, dynamic>>(
          '/exercises/1',
          fromJson: (json) => json as Map<String, dynamic>,
        );
        await pumpEventQueue();
        client.complete('/api/exercises/1', '{"id":"1"}');
        final response = await retry;

        expect(response.success, isTrue);
        expect(client.callCount, 2);
      },
    );
  });
}
