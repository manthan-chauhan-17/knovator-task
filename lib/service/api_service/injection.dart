import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:developer' as dev;

import 'package:knovator_task/service/api_service/rest_client.dart';

final restClient = RestClient(
  baseUrl: 'https://jsonplaceholder.typicode.com',
  dio,
);

final dio = getDio();

Dio getDio() {
  BaseOptions options = BaseOptions(
    receiveDataWhenStatusError: true,
    contentType: "application/json",
    sendTimeout: const Duration(seconds: 60),
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
  );

  Dio dio = Dio(options);
  dio.interceptors.add(LogInterceptor());
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (request, handler) {
        dev.log('Api Request Body: ${request.data}');
        return handler.next(request);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (response.statusCode == 200) {
          debugPrint('status code 200');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        final response = e.response;
        dev.log(
          'Api Error --> statusCode: ${response?.statusCode} --> ${response?.statusMessage} : Error ==> ${e.toString()}',
        );
        return handler.next(e);
      },
    ),
  );
  return dio;
}
