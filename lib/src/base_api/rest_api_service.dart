import 'dart:io';

import 'package:cloudflare/src/entity/cloudflare_response.dart';
import 'package:cloudflare/src/model/error_info.dart';
import 'package:cloudflare/src/model/error_response.dart';
import 'package:cloudflare/src/model/pagination.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cloudflare/src/base_api/c_response.dart';
import 'package:cloudflare/src/base_api/rest_api.dart';
import 'package:cloudflare/src/utils/jsonable.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

abstract class RestAPIService<I, DataType extends Jsonable, ErrorType> {

  static const authorizationKey = 'Authorization';

  static const Map<String, String> defaultHeaders = {
  };

  I service;
  DataType? dataType;
  ErrorType? errorType;
  RestAPI restAPI;

  RestAPIService({
    required this.restAPI,
    required this.service,
    this.dataType,
    this.errorType,
  });

  Future<CResponse> getSaveResponse<ContainerDataTypeGeneric>(Future futureResponse, {bool parseCloudflareResponse = true}) async {
    CResponse response = CResponse(
      http.Response('', HttpStatus.notFound),
      null,
    );

    CResponse httpResponseToCustomHttpResponse(HttpResponse response) {
      dynamic body = response.data;
      ErrorResponse? error;
      if(parseCloudflareResponse) {
        if(body is Map<String, dynamic>) {
          body = CloudflareResponse.fromJson(body);
        } else if(body is String) {
          body = CloudflareResponse().fromJsonString(body);
        }
        if(body is CloudflareResponse && !body.success) {
          error = ErrorResponse(
            errors: body.errors,
            messages: body.messages,
          );
        }
      }
      return CResponse(
        http.Response(
          '',
          response.response.statusCode ?? HttpStatus.notFound,
          headers: response.response.headers.map.map((key, value) => MapEntry(key, value.join('; '))),
          isRedirect: response.response.isRedirect ?? false,
          request: http.Request(
            response.response.requestOptions.method,
            response.response.requestOptions.uri,
          ),
        ),
        body,
        error: error,
        extraData: response
      );
    }

    CResponse<CloudflareResponse> dioErrorToCustomHttpResponse(dio.DioError error) =>
      CResponse(
        http.Response(
          '',
          error.response?.statusCode ?? HttpStatus.notFound,
          headers: error.response?.headers.map.map((key, value) => MapEntry(key, value.join('; '))) ?? {},
          isRedirect: error.response?.isRedirect ?? false,
          request: http.Request(
            error.response?.requestOptions.method ?? HttpMethod.GET,
            error.response?.requestOptions.uri ?? Uri(),
          ),
        ),
        null,
        error: error.response?.data ?? ErrorResponse(
          errors: [ErrorInfo(message: error.message)],
        ),
        extraData: error
      );

    try {
      final HttpResponse httpResponse = await futureResponse;
      response = httpResponseToCustomHttpResponse(httpResponse);
    } catch (e) {
      if (e is HttpResponse) {
        response = httpResponseToCustomHttpResponse(e);
      } else
      if (e is dio.DioError) {
        switch(e.type) {
          case dio.DioErrorType.connectTimeout:
          case dio.DioErrorType.receiveTimeout:
          case dio.DioErrorType.sendTimeout:
            throw TimeoutException(e.message);
          default:
        }
        if(e.error is Exception) throw e.error;
        response = dioErrorToCustomHttpResponse(e);
      } else {
        rethrow;
      }
    }
    return response;
  }

  Future<CResponse<DataType>> parseResponse(Future futureResponse, {bool parseCloudflareResponse = true}) async {
    return genericParseResponse(futureResponse, dataType: dataType, parseCloudflareResponse: parseCloudflareResponse);
  }

  Future<CResponse<List<DataType>>> parseResponseAsList(
      Future futureResponse, {bool parseCloudflareResponse = true}) async {
    return genericParseResponseAsList(futureResponse, dataType: dataType, parseCloudflareResponse: parseCloudflareResponse);
  }

  Future<CResponse<DataTypeGeneric>> genericParseResponse<DataTypeGeneric>(
      Future futureResponse, {DataTypeGeneric? dataType, bool parseCloudflareResponse = true}) async {
    CResponse response = await getSaveResponse(futureResponse, parseCloudflareResponse: parseCloudflareResponse);
    try {
      DataTypeGeneric? dataTypeResult;
      dynamic body = response.body;
      if(body is CloudflareResponse) body = response.body?.result;

      if(body is DataTypeGeneric) {
        dataTypeResult = body;
      } else
      if (dataType is Jsonable) {
        if(body is Map<String, dynamic>) {
          dataTypeResult = dataType.fromJsonMap(body) as DataTypeGeneric?;
        } else
        if(body is String) {
          dataTypeResult = dataType.fromJsonString(body) as DataTypeGeneric?;
        }
      }
      return CResponse<DataTypeGeneric>(response.base, dataTypeResult, error: response.error);
    } catch (e) {
      String message = e.toString();
      print(e);
      return CResponse<DataTypeGeneric>(
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
        error: message
      );
    }
  }

  Future<CResponse<List<DataTypeGeneric>>>
  genericParseResponseAsList<DataTypeGeneric extends Jsonable?>(
      Future futureResponse, {DataTypeGeneric? dataType, bool parseCloudflareResponse = true}) async {
    CResponse response = await getSaveResponse(futureResponse, parseCloudflareResponse: parseCloudflareResponse);
    try {
      List<DataTypeGeneric>? dataList;
      dynamic body = response.body;
      if(response.body is CloudflareResponse) {
        body = response.body?.result;
        Pagination? pagination = (response.body as CloudflareResponse).paginationInfo;
        if(pagination != null) {
          response.base.headers.addAll({
            Pagination.countHeader: '${pagination.count}',
            Pagination.totalCountHeader: '${pagination.totalCount}',
          });
        }
      }

      if(body is Map){
        for(dynamic value in body.values) {
          if(value is List<dynamic>) {
            body = value;
            break;
          }
        }
      }

      if(body is List<DataTypeGeneric>) {
        dataList = body;
      } else
      if (dataType is Jsonable) {
        if(body is List<dynamic>) {
          dataList = dataType.fromJsonList(body) as List<DataTypeGeneric>?;
        } else
        if(body is String) {
          dataList = dataType.fromJsonString(body) as List<DataTypeGeneric>?;
        }
      }
      return CResponse<List<DataTypeGeneric>>(response.base, dataList, error: response.error);
    } catch (e) {
      String message = e.toString();
      print(e);
      return CResponse<List<DataTypeGeneric>>(
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
        error: message
      );
    }
  }
}
