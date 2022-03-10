import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;

enum AppNetworkMethods { get, post, put, patch, delete }

class AppNetwork {
  static const _allowPayloadMethods = ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'];

  String path;
  Map<String, dynamic>? queryParameters;
  Map<String, String> headers = {};

  AppNetwork({
    required this.path,
    this.queryParameters,
  }) {
    if (base.User.authToken != null) {
      headers['Authorization'] = base.User.authToken!;
    }
  }

  Uri get uri {
    return config.AppSettings.apiUri.replace(
      path: '/api/${base.Intl.language}/$path',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> sendRequest({
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

    Future<dio.Response> responseFuture = dio.Dio().requestUri(
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

    return await _prepareResponse(responseFuture);
  }

  Future<Map<String, dynamic>> _prepareResponse(Future<dio.Response> responseFuture) async {
    print(000);
    try {
      dio.Response response = await responseFuture;

      return {
        'headers': response.headers,
        'body': response.data,
        'statusCode': response.statusCode,
      };
    } catch (e) {
      dio.DioError exception = e as dio.DioError;
      print(111);

      if (exception.error is SocketException) {
        print(222);

        if (config.AppSettings.navigatorKey.currentState != null) {
          await config.AppSettings.navigatorKey.currentState?.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AppError(
                exception: services.AppExceptionNoConnection(),
              ),
              transitionDuration: Duration.zero,
            ),
            (value) => false,
          );
        }

        print(333);

        throw services.AppExceptionNoConnection();
      }

      switch (exception.response?.statusCode) {
        case 401:
          await base.User.logout();
          await config.AppSettings.navigatorKey.currentState?.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AuthLogin(),
            ),
            (value) => false,
          );
          break;

        case 403:
          await config.AppSettings.navigatorKey.currentState?.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AppError(
                exception: services.AppExceptionNotAllowed(),
              ),
              transitionDuration: Duration.zero,
            ),
          );
          break;

        default:
          await config.AppSettings.navigatorKey.currentState?.push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AppError(
                exception: services.AppExceptionInternalError(),
              ),
              transitionDuration: Duration.zero,
            ),
          );
      }
    }

    return {};
  }
}
