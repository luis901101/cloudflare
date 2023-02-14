import 'dart:io';

import 'package:cloudflare/src/entity/cloudflare_response.dart';
import 'package:cloudflare/src/model/error_info.dart';
import 'package:cloudflare/src/model/cloudflare_error_response.dart';
import 'package:cloudflare/src/model/pagination.dart';
import 'package:cloudflare/src/utils/map_utils.dart';
import 'package:cloudflare/src/utils/params.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cloudflare/src/model/cloudflare_http_response.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract class RestAPIService<I, DataType extends Jsonable, ErrorType> {
  static const authorizationKey = 'Authorization';
  static const tusResumableKey = 'Tus-Resumable';
  static const uploadLengthKey = 'Upload-Length';
  static const uploadMetadataKey = 'Upload-Metadata';
  static const authorizedRequestAssertMessage = 'This endpoint requires an '
      'authorized request, check the Cloudflare constructor you are using and '
      'make sure you are using a valid `accountId` and `token`';
  static String bearer(String token) => 'Bearer $token';

  static const Map<String, dynamic> defaultHeaders = {};
  static const Map<String, dynamic> contentTypeJson = {
    Params.contentType: 'application/json'
  };

  I service;
  final String accountId;
  DataType? dataType;
  ErrorType? errorType;
  RestAPI restAPI;

  RestAPIService({
    required this.restAPI,
    required this.service,
    required this.accountId,
    this.dataType,
    this.errorType,
  });

  bool get isBasic => accountId.isEmpty;

  Future<CloudflareHTTPResponse> getSaveResponse<ContainerDataTypeGeneric>(
      Future futureResponse,
      {bool parseCloudflareResponse = true}) async {
    CloudflareHTTPResponse response = CloudflareHTTPResponse(
      http.Response('', HttpStatus.notFound),
      null,
    );

    CloudflareHTTPResponse httpResponseToCustomHttpResponse(
        HttpResponse response) {
      dynamic body = response.data;
      CloudflareErrorResponse? error;
      if (parseCloudflareResponse) {
        if (body is Map<String, dynamic>) {
          body = CloudflareResponse.fromJson(body);
        } else if (body is String) {
          body = CloudflareResponse().fromJsonString(body);
        }
        if (body is CloudflareResponse && !body.success) {
          error = CloudflareErrorResponse(
            errors: body.errors,
            messages: body.messages,
          );
        }
      }
      return CloudflareHTTPResponse(
          http.Response(
            '',
            response.response.statusCode ?? HttpStatus.notFound,
            headers: MapUtils.parseHeaders(response.response.headers) ?? {},
            isRedirect: response.response.isRedirect,
            request: http.Request(
              response.response.requestOptions.method,
              response.response.requestOptions.uri,
            ),
          ),
          body,
          error: error,
          extraData: response);
    }

    CloudflareHTTPResponse<CloudflareResponse> dioErrorToCustomHttpResponse(
            dio.DioError error) =>
        CloudflareHTTPResponse(
            http.Response(
              '',
              error.response?.statusCode ?? HttpStatus.notFound,
              headers: MapUtils.parseHeaders(error.response?.headers) ?? {},
              isRedirect: error.response?.isRedirect ?? false,
              request: http.Request(
                error.response?.requestOptions.method ?? HttpMethod.GET,
                error.response?.requestOptions.uri ?? Uri(),
              ),
            ),
            null,
            error: error.response?.data ??
                CloudflareErrorResponse(
                  errors: [ErrorInfo(message: error.message)],
                ),
            extraData: error);

    try {
      final HttpResponse httpResponse = await futureResponse;
      response = httpResponseToCustomHttpResponse(httpResponse);
    } catch (e) {
      if (e is HttpResponse) {
        response = httpResponseToCustomHttpResponse(e);
      } else if (e is dio.DioError) {
        switch (e.type) {
          case dio.DioErrorType.connectionTimeout:
          case dio.DioErrorType.receiveTimeout:
          case dio.DioErrorType.sendTimeout:
            throw TimeoutException(e.message);
          default:
        }
        if (e.error is Exception) throw e.error as Exception;
        response = dioErrorToCustomHttpResponse(e);
      } else {
        rethrow;
      }
    }
    return response;
  }

  Future<CloudflareHTTPResponse<DataType>> parseResponse(Future futureResponse,
      {bool parseCloudflareResponse = true}) async {
    return genericParseResponse(futureResponse,
        dataType: dataType, parseCloudflareResponse: parseCloudflareResponse);
  }

  Future<CloudflareHTTPResponse<List<DataType>>> parseResponseAsList(
      Future futureResponse,
      {bool parseCloudflareResponse = true}) async {
    return genericParseResponseAsList(futureResponse,
        dataType: dataType, parseCloudflareResponse: parseCloudflareResponse);
  }

  Future<CloudflareHTTPResponse<DataTypeGeneric>>
      genericParseResponse<DataTypeGeneric>(Future futureResponse,
          {DataTypeGeneric? dataType,
          bool parseCloudflareResponse = true}) async {
    CloudflareHTTPResponse response = await getSaveResponse(futureResponse,
        parseCloudflareResponse: parseCloudflareResponse);
    try {
      DataTypeGeneric? dataTypeResult;
      dynamic body = response.body;
      if (body is CloudflareResponse) body = response.body?.result;

      if (body is DataTypeGeneric) {
        dataTypeResult = body;
      } else if (dataType is Jsonable) {
        if (body is Map<String, dynamic>) {
          dataTypeResult = dataType.fromJsonMap(body) as DataTypeGeneric?;
        } else if (body is String) {
          dataTypeResult = dataType.fromJsonString(body) as DataTypeGeneric?;
        }
      }
      return CloudflareHTTPResponse<DataTypeGeneric>(
          response.base, dataTypeResult,
          error: response.error);
    } catch (e) {
      String message = e.toString();
      print(e);
      return CloudflareHTTPResponse<DataTypeGeneric>(
          http.Response(
            response.body?.toString() ?? '',
            Jsonable.jsonParserError,
            headers: response.base.headers,
            isRedirect: response.base.isRedirect,
            persistentConnection: response.base.persistentConnection,
            reasonPhrase: response.base.reasonPhrase,
            request: response.base.request,
          ),
          null,
          error: message);
    }
  }

  Future<CloudflareHTTPResponse<List<DataTypeGeneric>>>
      genericParseResponseAsList<DataTypeGeneric extends Jsonable?>(
          Future futureResponse,
          {DataTypeGeneric? dataType,
          bool parseCloudflareResponse = true}) async {
    CloudflareHTTPResponse response = await getSaveResponse(futureResponse,
        parseCloudflareResponse: parseCloudflareResponse);
    try {
      List<DataTypeGeneric>? dataList;
      dynamic body = response.body;
      if (response.body is CloudflareResponse) {
        body = response.body?.result;
        Pagination? pagination =
            (response.body as CloudflareResponse).paginationInfo;
        if (pagination != null) {
          response.base.headers.addAll({
            Pagination.countHeader: '${pagination.count}',
            Pagination.totalCountHeader: '${pagination.totalCount}',
          });
        }
      }

      if (body is Map) {
        for (dynamic value in body.values) {
          if (value is List<dynamic>) {
            body = value;
            break;
          }
        }
      }

      if (body is List<DataTypeGeneric>) {
        dataList = body;
      } else if (dataType is Jsonable) {
        if (body is List<dynamic>) {
          dataList = dataType.fromJsonList(body) as List<DataTypeGeneric>?;
        } else if (body is String) {
          dataList = dataType.fromJsonString(body) as List<DataTypeGeneric>?;
        }
      }
      return CloudflareHTTPResponse<List<DataTypeGeneric>>(
          response.base, dataList,
          error: response.error);
    } catch (e) {
      String message = e.toString();
      print(e);
      return CloudflareHTTPResponse<List<DataTypeGeneric>>(
          http.Response(
            response.body?.toString() ?? '',
            Jsonable.jsonParserError,
            headers: response.base.headers,
            isRedirect: response.base.isRedirect,
            persistentConnection: response.base.persistentConnection,
            reasonPhrase: response.base.reasonPhrase,
            request: response.base.request,
          ),
          null,
          error: message);
    }
  }
}
