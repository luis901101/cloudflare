import 'dart:io';

import 'package:cloudflare_sdk/src/entity/cloudflare_response.dart';
import 'package:cloudflare_sdk/src/model/error_info.dart';
import 'package:cloudflare_sdk/src/model/error_response.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' as dio;
import 'package:cloudflare_sdk/src/base_api/c_response.dart';
import 'package:cloudflare_sdk/src/base_api/rest_api.dart' as rest_api;
import 'package:cloudflare_sdk/src/utils/jsonable.dart';
import 'package:http/http.dart' as http;
import 'dart:async';


abstract class RestAPIService<I, DataType extends Jsonable, ErrorType> {

  static const authorizationKey = 'Authorization';

  static const Map<String, String> defaultHeaders = {
  };

  I service;
  DataType? dataType;
  ErrorType? errorType;
  rest_api.RestAPI restAPI;

  RestAPIService(
      this.service, {
        this.dataType,
        this.errorType,
        rest_api.RestAPI? restAPI,
      }) : restAPI = restAPI ?? rest_api.restAPI
  ;

  Future<CResponse<CloudflareResponse>> getSaveResponse(Future futureResponse) async {
    CResponse<CloudflareResponse> response = CResponse(
      http.Response('', HttpStatus.notFound),
      null,
    );

    CResponse<CloudflareResponse> httpResponseToCustomHttpResponse(HttpResponse response) {
      CloudflareResponse? body;
      if(response.data is CloudflareResponse) {
        body = response.data as CloudflareResponse;
      } else if(response.data is Map<String, dynamic>) {
        body = CloudflareResponse.fromJson(response.data);
      } else if(response.data is String) {
        body = CloudflareResponse().fromJsonString(response.data);
      }
      ErrorResponse? error;
      if(body != null && !body.success) {
        error = ErrorResponse(
          errors: body.errors,
          messages: body.messages,
        );
      }
      return CResponse<CloudflareResponse>(
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

  Future<CResponse<DataType>> parseResponse(Future futureResponse) async {
    return genericParseResponse(futureResponse, dataType: dataType);
  }

  Future<CResponse<List<DataType>>> parseResponseAsList(
      Future futureResponse) async {
    return genericParseResponseAsList(futureResponse, dataType: dataType);
  }

  Future<CResponse<DataTypeGeneric>> genericParseResponse<DataTypeGeneric extends Jsonable?>(
      Future futureResponse, {DataTypeGeneric? dataType}) async {
    CResponse<CloudflareResponse> response = await getSaveResponse(futureResponse);
    try {
      DataTypeGeneric? dataTypeResult;
      if (dataType != null) {
        if(response.body?.result is DataTypeGeneric) {
          dataTypeResult = response.body?.result;
        } else
        if(response.body?.result is String) {
          dataTypeResult = dataType.fromJsonString(response.body?.result) as DataTypeGeneric?;
        } else
        if(response.body?.result is Map) {
          dataTypeResult = dataType.fromJsonMap(response.body?.result) as DataTypeGeneric?;
        }
      }
      return CResponse<DataTypeGeneric>(response.base, dataTypeResult, error: response.error);
    } catch (e) {
      String message = e.toString();
      response = CResponse(
          http.Response(
            response.body?.toString() ?? '',
            Jsonable.jsonParserError,
            headers: response.base.headers,
            isRedirect: response.base.isRedirect,
            persistentConnection: response.base.persistentConnection,
            reasonPhrase: response.base.reasonPhrase,
            request: response.base.request,
          ),
          response.body,
          error: message);
      print(e);
    }
    return CResponse<DataTypeGeneric>(response.base, null, error: response.error);
  }

  Future<CResponse<List<DataTypeGeneric>>>
  genericParseResponseAsList<DataTypeGeneric extends Jsonable?>(
      Future futureResponse, {DataTypeGeneric? dataType}) async {
    CResponse response = await getSaveResponse(futureResponse);
    try {
      List<DataTypeGeneric>? dataList;
      if (dataType != null) {

        if(response.body?.result is List<DataTypeGeneric>) {
          dataList = response.body?.result;
        } else
        if(response.body?.result is String) {
          dataList = dataType.fromJsonStringList(response.body?.result) as List<DataTypeGeneric>?;
        } else
        if(response.body?.result is Map) {
          dataList = dataType.fromJsonList(response.body?.result) as List<DataTypeGeneric>?;
        }
      }
      return CResponse<List<DataTypeGeneric>>(response.base, dataList, error: response.error);
    } catch (e) {
      String message = e.toString();
      response = CResponse(
          http.Response(
            response.body?.toString() ?? '',
            Jsonable.jsonParserError,
            headers: response.base.headers,
            isRedirect: response.base.isRedirect,
            persistentConnection: response.base.persistentConnection,
            reasonPhrase: response.base.reasonPhrase,
            request: response.base.request,
          ),
          response.body,
          error: message);
      print(e);
    }
    return CResponse<List<DataTypeGeneric>>(response.base, null, error: response.error);
  }
}
