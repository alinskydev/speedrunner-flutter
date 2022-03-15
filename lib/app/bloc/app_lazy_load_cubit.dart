import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart' as dio;

import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class AppLazyLoadCubit extends Cubit<Map<String, dynamic>> {
  AppLazyLoadCubit() : super({});

  Future<void> process({
    required BuildContext context,
    required List<Widget> Function(BuildContext context, List records) builder,
    required services.AppNetwork apiRequest,
    required int page,
  }) async {
    emit({
      'records': null,
      'preloader': widgets.AppPreloader(),
    });

    apiRequest.queryParameters ??= {};
    apiRequest.queryParameters!['page'] = '$page';

    dio.Response data = await apiRequest.sendRequest();

    int realCurrentPage = int.parse(data.headers.value('x-pagination-current-page') ?? '1');

    if (page == realCurrentPage) {
      List records = data.data['data'];

      emit({
        'records': builder(context, records),
        'preloader': SizedBox(height: 30),
      });
    } else {
      emit({});
    }
  }
}
