extension DateTimeUtils on DateTime {
  String toJson() => toIso8601String();
  static DateTime fromJson(dynamic json) => DateTime.parse(json);
}
