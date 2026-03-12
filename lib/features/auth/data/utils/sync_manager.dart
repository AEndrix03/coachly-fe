import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SyncOperationType { create, update, delete }

class PendingOperation {
  final String id;
  final String entity;
  final SyncOperationType type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  PendingOperation({
    required this.id,
    required this.entity,
    required this.type,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entity': entity,
    'type': type.name,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory PendingOperation.fromJson(Map<String, dynamic> json) {
    return PendingOperation(
      id: json['id'],
      entity: json['entity'],
      type: SyncOperationType.values.firstWhere((e) => e.name == json['type']),
      data: json['data'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class SyncManager {
  static const String _pendingOpsKey = 'pending_operations';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> addOperation(PendingOperation operation) async {
    final ops = await getPendingOperations();
    ops.add(operation);
    await _saveOperations(ops);
  }

  Future<List<PendingOperation>> getPendingOperations() async {
    final json = await _storage.read(key: _pendingOpsKey);
    if (json == null) return [];
    final List<dynamic> list = jsonDecode(json);
    return list.map((e) => PendingOperation.fromJson(e)).toList();
  }

  Future<void> removeOperation(String id) async {
    final ops = await getPendingOperations();
    ops.removeWhere((op) => op.id == id);
    await _saveOperations(ops);
  }

  Future<void> clearAll() async {
    await _storage.delete(key: _pendingOpsKey);
  }

  Future<void> _saveOperations(List<PendingOperation> operations) async {
    final json = jsonEncode(operations.map((e) => e.toJson()).toList());
    await _storage.write(key: _pendingOpsKey, value: json);
  }

  Future<bool> hasPendingOperations() async {
    final ops = await getPendingOperations();
    return ops.isNotEmpty;
  }
}
