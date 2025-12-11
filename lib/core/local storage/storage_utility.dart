import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TLocalStorage {
  late final Box _box;

  static TLocalStorage? _instance;

  TLocalStorage._internal();

  factory TLocalStorage.instance() {
    _instance ??= TLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String boxName) async {
    await Hive.initFlutter();
    _instance = TLocalStorage._internal();
    _instance!._box = await Hive.openBox(boxName);
    debugPrint(
      'TLocalStorage: Initialized box: $boxName, keys: ${_instance!._box.keys}',
    );
  }

  Future<void> writeData<T>(String key, T value) async {
    try {
      if (value is List || value is Map || value is Set) {
        await _box.put(key, value);
      } else {
        await _box.put(key, value);
      }
      await _box.flush();
      debugPrint('TLocalStorage: Wrote data for key $key: $value');
    } catch (e) {
      debugPrint('TLocalStorage: Error writing data for key $key: $e');
      rethrow;
    }
  }

  T? readData<T>(String key) {
    try {
      final value = _box.get(key);
      debugPrint('TLocalStorage: Read data for key $key: $value');
      return value as T?;
    } catch (e) {
      debugPrint('TLocalStorage: Error reading data for key $key: $e');
      return null;
    }
  }

  Future<void> removeData(String key) async {
    try {
      await _box.delete(key);
      await _box.flush();
      debugPrint('TLocalStorage: Removed data for key $key');
    } catch (e) {
      debugPrint('TLocalStorage: Error removing data for key $key: $e');
      rethrow;
    }
  }

  Future<int> clearAll() async {
    try {
      final count = await _box.clear();
      await _box.flush();
      debugPrint('TLocalStorage: Cleared $count items from box');
      return count;
    } catch (e) {
      debugPrint('TLocalStorage: Error clearing box: $e');
      rethrow;
    }
  }
}
