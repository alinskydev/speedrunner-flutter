import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:dio/dio.dart' as dio;

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/services.dart' as services;

class AppNetworkForm extends StatefulWidget {
  base.Model model;
  services.AppNetwork apiRequest;
  String? successMessage;

  Widget Function(BuildContext context, _AppNetworkFormState formState) builder;
  void Function(BuildContext context, dio.Response response)? onSuccess;

  AppNetworkForm({
    Key? key,
    required this.model,
    required this.apiRequest,
    required this.builder,
    this.successMessage,
    this.onSuccess,
  }) : super(key: key);

  @override
  _AppNetworkFormState createState() => _AppNetworkFormState();
}

class _AppNetworkFormState extends State<AppNetworkForm> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      FormBuilderState formBuilderState = formKey.currentState!;

      formBuilderState.patchValue(
        formBuilderState.fields.map((key, value) {
          var initialValue = widget.model.getValue(key, asString: false);

          switch (value.widget.runtimeType) {
            case FormBuilderDateTimePicker:
              initialValue = initialValue != null ? base.Singletons.settings.dateFormat.parse(initialValue) : null;
              break;
            case FormBuilderFilePicker:
              initialValue = List<PlatformFile>.from([]);
              break;
          }

          return MapEntry(key, initialValue);
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: widget.builder(context, this),
    );
  }

  void validate() async {
    Map<String, dynamic> formData = formKey.currentState!.fields.map((key, value) {
      var initialValue = value.value;

      if (initialValue != null) {
        switch (value.widget.runtimeType) {
          case FormBuilderDateTimePicker:
            initialValue = base.Singletons.settings.dateFormat.format(initialValue);
            break;
          case FormBuilderFilePicker:
            FormBuilderFilePicker filePicker = value.widget as FormBuilderFilePicker;

            if (!filePicker.allowMultiple && initialValue.isNotEmpty) {
              initialValue = initialValue[0];
            }

            break;
        }
      }

      return MapEntry(key, initialValue);
    });

    dio.Response response = await widget.apiRequest.sendRequest(
      method: services.AppNetworkMethods.post,
      data: formData,
      isMultipart: true,
    );

    Map<String, String> fieldsErrors = {};

    switch (response.statusCode) {
      case 422:
        fieldsErrors = Map.from(response.data['message']).map((key, value) {
          return MapEntry(key, value[0]);
        });
        break;
    }

    formKey.currentState!.validate();
    fieldsErrors.forEach((key, value) {
      formKey.currentState!.fields[key]?.invalidate(value);
    });

    if (fieldsErrors.isEmpty) {
      if (widget.successMessage != null) {
        services.AppNotificator(context).sendMessage(
          message: widget.successMessage!,
        );
      }

      if (widget.onSuccess != null) {
        widget.onSuccess!(context, response);
      }
    } else {
      services.AppNotificator(context).sendMessage(
        message: fieldsErrors.values.join('\n'),
        type: services.AppNotificatorTypes.error,
      );
    }
  }
}
