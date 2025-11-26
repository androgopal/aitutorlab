import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer';


class ApiService {

  final String _baseUrl = 'https://studykee.com/projects/mtresin/api/';
  late Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
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
}