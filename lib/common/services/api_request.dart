import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/base/config.dart' as config;

class ApiRequest {
  String path;
  Map<String, dynamic>? queryParameters;

  ApiRequest({
    required this.path,
    this.queryParameters,
  });

  Future<Map<String, dynamic>> getData() async {
    Future<http.Response> responseFuture = Future.delayed(Duration(seconds: 1), () {
      return http.get(_prepareUri());
    });

    return await _prepareResponse(responseFuture);
  }

  Future<Map<String, dynamic>> sendJson([Map body = const {}]) async {
    Future<http.Response> responseFuture = Future.delayed(Duration(seconds: 1), () {
      return http.post(
        _prepareUri(),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
    });

    return await _prepareResponse(responseFuture);
  }

  Future<Map<String, dynamic>> sendFormData([Map<String, dynamic> fields = const {}]) async {
    http.MultipartRequest request = http.MultipartRequest('POST', _prepareUri());

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
        default:
          throw 'An error occurred';
      }
    });
  }

  Uri _prepareUri() {
    return Uri(
      scheme: config.api['scheme'],
      host: config.api['host'],
      path: '/api/$path',
      queryParameters: queryParameters,
    );
  }

  Future<Map<String, dynamic>> _prepareResponse(Future<http.Response> responseFuture) {
    return responseFuture.then((response) {
      switch (response.statusCode) {
        case 200:
        case 422:
          return {
            'headers': response.headers,
            'body': json.decode(response.body),
            'statusCode': response.statusCode,
          };
        default:
          throw 'An error occurred';
      }
    });
  }
}
