import 'package:dio/dio.dart';
import 'dart:developer';

import 'package:flutter/material.dart';

class ApiService {
  // <-- set the correct baseUrl
  final String _baseUrl = 'https://www.skcip.in/api/';
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
        // Don't throw for 4xx here so we can inspect response body
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Logging of request, body and response
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST[${options.method}] => PATH: ${options.uri}');
          log('REQUEST[DATA] => ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE[${response.statusCode}] => ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('ERROR[${e.response?.statusCode ?? e.type}] => MESSAGE: ${e.message}');
          log('ERROR[DATA] => ${e.response?.data}');
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> getRequest(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      // Give caller full response data if available
      debugPrint("GET Exception status: ${e.response?.statusCode} data: ${e.response?.data}");
      rethrow;
    } catch (e) {
      log('Unexpected error in GET request: $e');
      rethrow;
    }
  }

  /// Note: path is first positional, data is named. Call like:
  /// await apiService.postRequest('register-process', data: userData);
  Future<dynamic> postRequest(String path, {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
      );

      // Log important details (already logged by interceptor)
      log('API[$path] status: ${response.statusCode}');

      // If status is 200/201 -> return body
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      }

      // For 4xx responses return response.data so caller can inspect validation errors
      // We throw an error that includes the response so caller can catch e.response
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Request failed with status ${response.statusCode}',
        type: DioExceptionType.badResponse,
      );
    } on DioException catch (e) {
      // Re-throw with full response available to caller
      log('POST DioException: status=${e.response?.statusCode} data=${e.response?.data}');
      rethrow;
    } catch (e) {
      log('Unexpected error in POST request: $e');
      rethrow;
    }
  }
}





/*
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import '../Constant.dart';


class ApiService {

  final String _baseUrl = Constant.BASE_URL;
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 50),
        receiveTimeout: const Duration(seconds: 30),
        // You can add headers here, e.g., 'Authorization', 'Content-Type'
        headers: {
          'Content-Type': 'application/json',
          // 'Accept': 'application/json',
        },
      ),
    );

    // Optional: Add logging interceptor for debugging network calls
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          log('RESPONSE[${response.statusCode}]');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          log('ERROR[${e.response?.statusCode ?? e.type}] => MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  /// Handles GET requests.
  ///
  /// - [path]: The endpoint path (e.g., '/users').
  /// - [queryParameters]: Optional map of query parameters.
  Future<dynamic> getRequest(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      // Dio throws an exception for 4xx/5xx status codes, so we only handle success here.
      return response.data;
    } on DioException catch (e) {
      // Re-throw the structured error for the calling widget/bloc to handle
      throw _handleDioError(e);
    } catch (e) {
      log('Unexpected error in GET request: $e');
      throw 'An unexpected error occurred.';
    }
  }

  /// Handles POST requests.
  ///
  /// - [path]: The endpoint path (e.g., '/login').
  /// - [data]: The data payload to be sent in the request body (usually a Map).
  Future<dynamic> postRequest(String path, {required Map<String, dynamic> data}) async {
    try {
      final response = await _dio.post(
        path,
        data: data, // The body data
      );
      // Dio throws an exception for 4xx/5xx status codes, so we only handle success here.
      return response.data;
    } on DioException catch (e) {
      // Re-throw the structured error for the calling widget/bloc to handle
      throw _handleDioError(e);
    } catch (e) {
      log('Unexpected error in POST request: $e');
      throw 'An unexpected error occurred.';
    }
  }

  /// Internal utility to convert a DioException into a meaningful error string.
  String _handleDioError(DioException e) {
    String errorDescription = '';
    switch (e.type) {
      case DioExceptionType.cancel:
        errorDescription = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "Connection timeout with API server";
        break;
      case DioExceptionType.unknown:
        errorDescription = "No internet connection or server unreachable";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
      // Handle specific status codes
        switch (e.response?.statusCode) {
          case 400:
            errorDescription = "Bad Request (400): ${e.response?.data}";
            break;
          case 401:
            errorDescription = "Unauthorized (401): Invalid credentials";
            break;
          case 403:
            errorDescription = "Forbidden (403): Access denied";
            break;
          case 404:
            errorDescription = "Not Found (404): The requested resource was not found";
            break;
          case 500:
            errorDescription = "Internal Server Error (500)";
            break;
          default:
            errorDescription = "Received invalid status code: ${e.response?.statusCode}";
            break;
        }
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "Send timeout in connection with API server";
        break;
      case DioExceptionType.badCertificate:
        errorDescription = "SSL certificate verification failed";
        break;
      case DioExceptionType.connectionError:
        errorDescription = "Connection Error. Check your internet connectivity.";
        break;
    }
    return errorDescription;
  }
}*/
