import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/base/model.dart';
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class SRLazyLoadCubit extends Cubit<Map<String, dynamic>> {
  SRLazyLoadCubit() : super({});

  Future<void> process({
    required BuildContext context,
    required List<Widget> Function(BuildContext context, List records) builder,
    required services.SRApiRequest apiRequest,
    required int page,
  }) async {
    emit({
      'records': null,
      'preloader': widgets.AppPreloader(),
    });

    apiRequest.queryParameters ??= {};
    apiRequest.queryParameters!['page'] = '$page';

    Map data = await apiRequest.getData();

    int realCurrentPage = int.parse(data['headers']['x-pagination-current-page']);

    if (page == realCurrentPage) {
      List records = data['body']['data'];

      emit({
        'records': builder(context, records),
        'preloader': SizedBox(height: 30),
      });
    } else {
      emit({});
    }
  }
}
