import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/base.dart' as base;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class AppLiveSearchSelect extends StatelessWidget {
  String valuePath;
  String textPath;
  bool isLocalized;

  Widget Function(BuildContext context, List<FormBuilderFieldOption> options) builder;

  AppLiveSearchSelect({
    Key? key,
    required this.valuePath,
    required this.textPath,
    this.isLocalized = false,
    required this.builder,
  }) : super(key: key) {
    textPath += isLocalized ? '.${base.Singletons.intl.language}' : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLiveSearchSelectCubit, List<Map>>(
      builder: (context, state) {
        List<FormBuilderFieldOption> options = state.map((e) {
          String text = e.getValueFromPath(textPath) as String? ?? '';

          return FormBuilderFieldOption(
            value: e.getValueFromPath(valuePath),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(text),
            ),
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            !state.isEmpty
                ? IconButton(
                    onPressed: () {
                      context.read<widgets.AppLiveSearchSelectCubit>().clear();
                    },
                    icon: Icon(Icons.close),
                  )
                : SizedBox(),
            builder(context, options),
          ],
        );
      },
    );
  }
}

class AppLiveSearchSelectCubit extends Cubit<List<Map>> {
  AppLiveSearchSelectCubit() : super([]);

  Future<void> process({
    required services.AppNetwork apiRequest,
  }) async {
    List<Map> data = await apiRequest.sendRequest().then((value) {
      return List<Map>.from(value.data['data']);
    });

    emit(data);
  }

  Future<void> clear() async {
    emit([]);
  }
}
