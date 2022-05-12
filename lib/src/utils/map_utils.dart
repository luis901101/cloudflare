import 'dart:convert';
import 'package:dio/dio.dart' as dio;

extension MapExtension<K, V> on Map<K, V> {
  Map<K2, V2> mapWhere<K2, V2>(
      MapEntry<K2, V2> Function(K key, V value) convert,
      bool Function(K key, V value) test) {
    Map<K2, V2> result = {};
    forEach((key, value) {
      if (test(key, value)) {
        final entry = convert(key, value);
        result[entry.key] = entry.value;
      }
    });
    return result;
  }
}

class MapUtils {
  static Map<String, String>? parseHeaders(dio.Headers? headers) =>
      parseMapListHeaders(headers?.map);

  static Map<String, String>? parseMapListHeaders(
          Map<String, List<String>>? map) =>
      map?.map((key, value) => MapEntry(key, value.join('; ')));

  static Map<String, String>? parseMapDynamicHeaders(
          Map<String, dynamic>? map) =>
      map?.mapWhere(
        (key, value) => MapEntry<String, String>(
            key, value is String ? value : jsonEncode(value)),
        (key, value) => value != null,
      );
}
