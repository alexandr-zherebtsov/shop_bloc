import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shop_bloc/core/utils/extensions/string_extension.dart';

class DioManager {
  final String _baseUrl;
  final String _version;
  final String _platform;
  final String _device;
  final String _lang;

  DioManager({
    required final String baseUrl,
    required final String version,
    required final String platform,
    required final String device,
    required final String lang,
  })  : _baseUrl = baseUrl,
        _version = version,
        _platform = platform,
        _device = device,
        _lang = lang;

  Dio? _dioInstance;

  Dio? get dio {
    _dioInstance ??= initDio();
    return _dioInstance;
  }

  String? accessToken;

  Dio initDio() {
    final Dio dio = Dio(
      BaseOptions(
        // baseUrl: _baseUrl,
        baseUrl: 'https://api.themoviedb.org/3',
        queryParameters: {
          'api_key' : '10d39203e458fc0a8dec50a358c99540',
        },
        headers: <String, String>{
          'Content-Type': 'application/json',
          'device': _device,
          'platform': _platform,
          'version': _version,
          'lang': _lang,
          if (accessToken.isNotNullOrEmpty())
            'Authorization': 'Bearer $accessToken'
        },
        sendTimeout: const Duration(milliseconds: 20000),
        connectTimeout: const Duration(milliseconds: 20000),
        receiveTimeout: const Duration(milliseconds: 60000),
      ),
    );
    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }
    return dio;
  }

  void update() => _dioInstance = initDio();

  /// DIO GET
  /// take [url], concrete route
  Future<Response> get(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? json,
  }) async {
    return await dio!
        .get(
      url,
      queryParameters: json,
      options: Options(headers: headers),
    )
        .then((response) {
      return response;
    });
  }

  /// DIO POST
  /// take [url], concrete route
  Future<Response> post(
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) async {
    return await dio!
        .post(
      url,
      data: body,
      options: Options(headers: headers),
    )
        .then((response) {
      return response;
    });
  }

  /// DIO PUT
  /// take [url], concrete route
  Future<Response> put(
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) async {
    return await dio!
        .put(
      url,
      data: body,
      options: Options(headers: headers),
    )
        .then((response) {
      return response;
    });
  }

  /// DIO DELETE
  /// take [url], concrete route
  Future<Response> delete(
    String url, {
    Map<String, dynamic>? headers,
    dynamic body,
  }) async {
    return await dio!
        .delete(
      url,
      data: body,
      options: Options(headers: headers),
    )
        .then((response) {
      return response;
    });
  }
}
