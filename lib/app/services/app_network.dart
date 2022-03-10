import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;

class AppNetwork {
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

  Future<Map<String, dynamic>> getData() async {
    Future<http.Response> responseFuture = http.get(
      uri,
      headers: headers,
    );

    http.Response response = await _checkConnection(responseFuture) as http.Response;
    return await _prepareResponse(response);
  }

  Future<Map<String, dynamic>> sendJson([Map body = const {}]) async {
    headers['Content-Type'] = 'application/json';

    Future<http.Response> responseFuture = http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    http.Response response = await _checkConnection(responseFuture) as http.Response;
    return await _prepareResponse(response);
  }

  Future<Map<String, dynamic>> sendFormData([Map<String, dynamic> fields = const {}]) async {
    http.MultipartRequest request = http.MultipartRequest('POST', uri);

    headers.forEach((key, value) {
      request.headers[key] = value;
    });

    fields.forEach((key, value) async {
      if (value is List) {
        value.forEach((element) async {
          switch (element.runtimeType) {
            case PlatformFile:
              element = element as PlatformFile;

              if (element.path != null) {
                http.MultipartFile file = await http.MultipartFile.fromPath('$key[]', element.path ?? '');
                request.files.add(file);
              }
              break;
            default:
              request.fields[key] = element == null ? '$element' : '';
              break;
          }
        });
      } else {
        switch (value.runtimeType) {
          case PlatformFile:
            value = value as PlatformFile;

            if (value.path != null) {
              http.MultipartFile file = await http.MultipartFile.fromPath(key, value.path ?? '');
              request.files.add(file);
            }
            break;
          default:
            request.fields[key] = value != null ? '$value' : '';
            break;
        }
      }
    });

    http.StreamedResponse response = await _checkConnection(request.send()) as http.StreamedResponse;
    return await _prepareResponse(response);
  }

  Future<http.BaseResponse> _checkConnection(Future<http.BaseResponse> responseFuture) async {
    try {
      return await responseFuture;
    } catch (e) {
      if (config.AppSettings.navigatorKey.currentState != null) {
        await config.AppSettings.navigatorKey.currentState?.push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => views.AppError(
              exception: services.AppExceptionNoConnection(),
            ),
            transitionDuration: Duration.zero,
          ),
        );
      }

      throw services.AppExceptionNoConnection();
    }
  }

  Future<Map<String, dynamic>> _prepareResponse(http.BaseResponse response) async {
    switch (response.statusCode) {
      case 200:
      case 422:
        String body = '';

        switch (response.runtimeType) {
          case http.Response:
            body = (response as http.Response).body;
            break;
          case http.StreamedResponse:
            body = await (response as http.StreamedResponse).stream.bytesToString();
            break;
        }

        return {
          'headers': response.headers,
          'body': json.decode(body),
          'statusCode': response.statusCode,
        };

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

    return {};
  }
}
