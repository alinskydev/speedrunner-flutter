import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:dio/dio.dart' as dio;

import '/libraries/base.dart' as base;
import '/libraries/services.dart' as services;

class NetworkForm extends StatefulWidget {
  Widget Function(BuildContext context, _NetworkFormState formState) builder;
  base.Model model;
  services.AppNetwork network;

  void Function(BuildContext context, dio.Response response)? onSuccess;

  NetworkForm({
    Key? key,
    required this.builder,
    required this.model,
    required this.network,
    this.onSuccess,
  }) : super(key: key);

  @override
  _NetworkFormState createState() => _NetworkFormState();
}

class _NetworkFormState extends State<NetworkForm> {
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
    FormBuilderState formBuilderState = formKey.currentState!;

    // Preparing

    Map<String, dynamic> formData = formBuilderState.fields.map((key, value) {
      var initialValue = value.value;

      if (initialValue != null) {
        switch (value.widget.runtimeType) {
          case FormBuilderDateTimePicker:
            initialValue = base.Singletons.settings.dateFormat.format(initialValue);
            break;
          case FormBuilderFilePicker:
            bool allowMultiple = (value.widget as FormBuilderFilePicker).allowMultiple;
            bool isNotEmpty = (initialValue as List).isNotEmpty;

            if (!allowMultiple && isNotEmpty) {
              initialValue = initialValue[0];
            }

            break;
        }
      }

      return MapEntry(key, initialValue);
    });

    dio.Response response = await widget.network.sendRequest(
      method: services.AppNetworkMethods.post,
      data: formData,
      isMultipart: true,
    );

    // Validation

    Map<String, String> errors = {};

    switch (response.statusCode) {
      case 422:
        errors = Map.from(response.data['message']).map((key, value) {
          return MapEntry(key, value[0]);
        });
        break;
    }

    formBuilderState.validate();

    errors.forEach((key, value) {
      formBuilderState.fields[key]?.invalidate(value);
    });

    // Sending notification

    if (errors.isEmpty) {
      if (widget.onSuccess != null) {
        widget.onSuccess!(context, response);
      }
    } else {
      services.AppNotificator(context).sendMessage(
        errors.values.join('\n'),
        color: base.Singletons.style.colors.primary,
      );
    }
  }
}
