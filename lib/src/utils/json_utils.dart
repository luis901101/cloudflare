import 'dart:convert';

import 'package:cloudflare/src/utils/jsonable.dart';

class JsonUtils {
  static Map<String, dynamic>? jsonableToJson(Jsonable? value) =>
      value?.toJson();
  static Jsonable<T>? jsonableFromJson<T extends Object>(
      Map<String, dynamic>? json) => null;

  static String? toJsonString(dynamic value) => value?.toString();
  static String? doubleToJsonString2Digits(double? value) => value?.toStringAsFixed(
      2);

  static int? intFromJson(dynamic json) => int.tryParse(json?.toString() ?? '');
  static dynamic intReadValue(Map map, String key) => int.tryParse(map[key]?.toString() ?? '');

  static double? doubleFromJson(dynamic json) => double.tryParse(json
          ?.toString() ??
      '');
  static num? numFromJson(dynamic json) => num.tryParse(json?.toString() ??
      '');
  static String? stringFromJson(dynamic json) => json?.toString();

  static dynamic stringToMapReadValue(Map map, String key) {
    final data = map[key];
    if(data is Map) return data;
    if(data is String) return jsonDecode(data);
    return data;
  }
}
