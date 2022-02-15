import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/views.dart' as views;

class ApiRequest {
  String path;
  Map<String, dynamic>? queryParameters;
  Map<String, String> headers = {};

  ApiRequest({
    required this.path,
    this.queryParameters,
  }) {
    if (base.User.authToken != null) {
      headers = {
        'Authorization': base.User.authToken!,
      };
    }
  }

  Future<Map<String, dynamic>> getData() async {
    Future<http.Response> responseFuture = Future.delayed(Duration(seconds: 0), () {
      return http.get(
        _prepareUri(),
        headers: headers,
      );
    });

    return await _prepareResponse(responseFuture);
  }

  Future<Map<String, dynamic>> sendJson([Map body = const {}]) async {
    Future<http.Response> responseFuture = Future.delayed(Duration(seconds: 0), () {
      headers.addAll({
        'Content-Type': 'application/json',
      });

      return http.post(
        _prepareUri(),
        headers: headers,
        body: jsonEncode(body),
      );
    });

    return await _prepareResponse(responseFuture);
  }

  Future<Map<String, dynamic>> sendFormData([Map<String, dynamic> fields = const {}]) async {
    http.MultipartRequest request = http.MultipartRequest('POST', _prepareUri());

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

    return await request.send().then((response) async {
      switch (response.statusCode) {
        case 200:
        case 422:
          String body = await response.stream.bytesToString();

          return {
            'headers': response.headers,
            'body': json.decode(body),
            'statusCode': response.statusCode,
          };
        case 401:
          await base.Config.navigatorKey.currentState?.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AuthLogin(),
              transitionDuration: Duration.zero,
            ),
            (value) => false,
          );

          break;
        default:
          throw 'An error occurred';
      }

      return {};
    });
  }

  Uri _prepareUri() {
    return Uri.parse(base.Config.api['url']).replace(
      path: '/api/$path',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> _prepareResponse(Future<http.Response> responseFuture) {
    return responseFuture.then((response) async {
      switch (response.statusCode) {
        case 200:
        case 422:
          return {
            'headers': response.headers,
            'body': json.decode(response.body),
            'statusCode': response.statusCode,
          };
        case 401:
          await base.Config.navigatorKey.currentState?.pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => views.AuthLogin(),
              transitionDuration: Duration.zero,
            ),
            (value) => false,
          );

          break;
        default:
          throw 'An error occurred';
      }

      return {};
    });
  }
}
