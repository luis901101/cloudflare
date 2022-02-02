import 'dart:convert';

abstract class Jsonable<T extends Object> {
  static const int jsonParserError = 1000;

  ///
  /// This is just to suggest children to implement a named constructor to
  /// support creating objects fromJson(...) and fromJsonString(...) as easy as
  /// T.build().fromJson(...) or T.build().fromJsonString(...)

  @override
  String toString() => toJsonString();

  Map<String, dynamic> toJson();

  Map<String, dynamic> toJsonMap() => toJson();

  T? fromJsonMap(Map<String, dynamic>? json);

  String toJsonString() => jsonEncode(this);

  T? fromJsonString(String? json) =>
      fromJsonStringGeneric<T>(json, fromJsonMap);

  List<T>? fromJsonStringList(String? jsonStringList) =>
      fromJsonStringListGeneric<T>(jsonStringList, fromJsonMap);

  List<T>? fromJsonList(List<dynamic>? jsonList) =>
      fromJsonListGeneric<T>(jsonList, fromJsonMap);

  static T? fromJsonStringGeneric<T>(
          String? json, T? Function(Map<String, dynamic>? json) fromJsonMap) =>
      (json?.isNotEmpty ?? true) ? fromJsonMap.call(jsonDecode(json!)) : null;

  static List<T>? fromJsonStringListGeneric<T>(
          String? jsonStringList, T? Function(Map<String, dynamic> json) fromJsonMap) =>
        (jsonStringList?.isNotEmpty ?? true)
          ? fromJsonListGeneric(jsonDecode(jsonStringList!), fromJsonMap)
          : null;

  static List<T>? fromJsonListGeneric<T>(
      List<dynamic>? jsonList, T? Function(Map<String, dynamic> json) fromJsonMap) {
    if (jsonList == null) return null;
    if (jsonList.isEmpty) return [];
    List<T> list = jsonList.map((dynamic json) {
      if (json is! Map<String, dynamic>) {
        throw Exception(
            'fromJsonList(List<dynamic> jsonList) expects a Json Map<String, dynamic> but other object was found instead');
      }
      return fromJsonMap.call(json)!;
    }).toList();
    return list;
  }

  ///  Factory constructor is required to work with automatic json serialization
  ///  factory T.fromJson(Map<String, dynamic> json) => _$TFromJson(json);
}
