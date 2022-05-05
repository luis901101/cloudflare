// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _StreamService implements StreamService {
  _StreamService(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<CloudflareResponse?>> streamFromUrl(
      {required data, onUploadProgress}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<HttpResponse<CloudflareResponse>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/copy',
                    queryParameters: queryParameters,
                    data: _data,
                    onSendProgress: onUploadProgress)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data == null
        ? null
        : CloudflareResponse.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<CloudflareResponse?>> streamFromFile(
      {required file, onUploadProgress}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromFileSync(file.path,
            filename: file.path.split(Platform.pathSeparator).last)));
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<HttpResponse<CloudflareResponse>>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, '',
                queryParameters: queryParameters,
                data: _data,
                onSendProgress: onUploadProgress)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data == null
        ? null
        : CloudflareResponse.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<CloudflareResponse?>> streamFromBytes(
      {required bytes, onUploadProgress}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.files.add(MapEntry(
        'file',
        MultipartFile.fromBytes(
          bytes,
          filename: 'video-from-bytes',
        )));
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<HttpResponse<CloudflareResponse>>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, '',
                queryParameters: queryParameters,
                data: _data,
                onSendProgress: onUploadProgress)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data == null
        ? null
        : CloudflareResponse.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<CloudflareResponse?>> getAll(
      {after, before, includeCounts, search, limit, asc, status}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'after': after,
      r'before': before,
      r'include_counts': includeCounts,
      r'search': search,
      r'limit': limit,
      r'asc': asc,
      r'status': status
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<HttpResponse<CloudflareResponse>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data == null
        ? null
        : CloudflareResponse.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<CloudflareResponse?>> get({required id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>?>(
        _setStreamType<HttpResponse<CloudflareResponse>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/${id}',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data == null
        ? null
        : CloudflareResponse.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<dynamic>> delete({required id}) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(
        Options(method: 'DELETE', headers: _headers, extra: _extra)
            .compose(_dio.options, '/${id}',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
