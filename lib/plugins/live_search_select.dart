import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/base.dart' as base;
import '/libraries/plugins.dart' as plugins;
import '/libraries/services.dart' as services;

class LiveSearchSelect extends StatelessWidget {
  Widget Function(BuildContext context, List<FormBuilderFieldOption> options) builder;

  String valuePath;
  String textPath;
  bool isLocalized;

  LiveSearchSelect({
    Key? key,
    required this.builder,
    required this.valuePath,
    required this.textPath,
    this.isLocalized = false,
  }) : super(key: key) {
    textPath += isLocalized ? '.${base.Singletons.intl.language}' : '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveSearchSelectCubit, List<Map>>(
      builder: (context, state) {
        List<FormBuilderFieldOption> options = state.map((e) {
          String text = (e.getValueFromPath(textPath) ?? '').toString();

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
                      context.read<plugins.LiveSearchSelectCubit>().clear();
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

class LiveSearchSelectCubit extends Cubit<List<Map>> {
  LiveSearchSelectCubit() : super([]);

  Future<void> process({
    required services.AppNetwork network,
  }) async {
    List<Map> data = await network.sendRequest().then((value) {
      return List<Map>.from(value.data['data']);
    });

    emit(data);
  }

  Future<void> clear() async {
    emit([]);
  }
}
