import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;

enum AppNetworkMethods { get, post, put, patch, delete }

class AppNetwork {
  String path;
  Map<String, dynamic>? queryParameters;
  Map<String, String> headers = {};

  AppNetwork({
    required this.path,
    this.queryParameters,
  }) {
    if (base.Singletons.user.authToken != null) {
      headers['Authorization'] = base.Singletons.user.authToken!;
    }
  }

  Uri get uri {
    return base.Singletons.settings.apiUri.replace(
      path: '/api/${base.Singletons.intl.language}/$path',
      queryParameters: queryParameters,
    );
  }

  Future<dio.Response> sendRequest({
    AppNetworkMethods method = AppNetworkMethods.get,
    Map<String, dynamic> data = const {},
    bool isMultipart = false,
  }) async {
    // headers['Content-Type'] = 'application/json';

    var fields;

    if (isMultipart) {
      fields ??= <String, dynamic>{};

      for (var entry in data.entries) {
        String key = entry.key;
        var value = entry.value;

        if (value is List) {
          key += '[]';
          List listValue = [];

          for (int i = 0; i < value.length; i++) {
            switch (value[i].runtimeType) {
              case PlatformFile:
                if (value[i].path != null) {
                  listValue.add(await dio.MultipartFile.fromFile(value[i].path!));
                }
                break;
              default:
                listValue.add(value[i] != null ? '${value[i]}' : '');
                break;
            }
          }

          fields[key] = listValue;
        } else {
          switch (value.runtimeType) {
            case PlatformFile:
              value = value as PlatformFile;

              if (value.path != null) {
                fields[key] = await dio.MultipartFile.fromFile(value.path!);
              }
              break;
            default:
              fields[key] = value != null ? '$value' : '';
              break;
          }
        }
      }

      fields = dio.FormData.fromMap(fields);
    } else {
      fields = data;
    }

    Future<dio.Response> request = dio.Dio().requestUri(
      uri,
      data: fields,
      options: dio.Options(
        method: method.name.toUpperCase(),
        headers: headers,
        followRedirects: false,
        validateStatus: (status) {
          return [200, 422].contains(status);
        },
      ),
    );

    return await _prepareResponse(request);
  }

  Future<dio.Response> _prepareResponse(Future<dio.Response> request) async {
    try {
      return await request;
    } on dio.DioError catch (e) {
      if (e.error is SocketException) {
        if (base.Singletons.settings.navigatorKey.currentState != null) {
          await base.Singletons.settings.navigatorKey.currentState!.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AppError(
                exception: services.AppExceptionNoConnection(),
              ),
              transitionDuration: Duration.zero,
            ),
            (route) => false,
          );
        }

        throw services.AppExceptionNoConnection();
      }

      switch (e.response?.statusCode) {
        case 401:
          await base.Singletons.user.logout();
          await base.Singletons.settings.navigatorKey.currentState?.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AuthLogin(),
            ),
            (value) => false,
          );
          break;

        case 403:
          await base.Singletons.settings.navigatorKey.currentState?.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AppError(
                exception: services.AppExceptionNotAllowed(),
              ),
              transitionDuration: Duration.zero,
            ),
          );
          break;

        default:
          await base.Singletons.settings.navigatorKey.currentState?.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AppError(
                exception: services.AppExceptionInternalError(),
              ),
              transitionDuration: Duration.zero,
            ),
          );
      }
    }

    throw services.AppExceptionInternalError();
  }
}
