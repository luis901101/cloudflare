import 'package:dio/dio.dart' as dio;

class MapUtils {
  static Map<String, String>? parseHeaders(dio.Headers? headers) =>
      parseMapListHeaders(headers?.map);

  static Map<String, String>? parseMapListHeaders(
    Map<String, List<String>>? map,
  ) => map?.map((key, value) => MapEntry(key, value.join('; ')));
}
