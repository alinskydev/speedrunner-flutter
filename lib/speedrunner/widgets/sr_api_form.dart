import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class SRApiForm extends StatefulWidget {
  base.Model model;
  services.SRApiRequest apiRequest;
  Widget? successMessage;

  Widget Function(BuildContext context, _SRApiFormState formState) builder;
  void Function(BuildContext context, Map<String, dynamic> response)? onSuccess;

  SRApiForm({
    Key? key,
    required this.model,
    required this.apiRequest,
    required this.builder,
    this.successMessage,
    this.onSuccess,
  }) : super(key: key);

  @override
  _SRApiFormState createState() => _SRApiFormState();
}

class _SRApiFormState extends State<SRApiForm> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      FormBuilderState formBuilderState = formKey.currentState!;

      formBuilderState.patchValue(
        formBuilderState.fields.map((key, value) {
          var initialValue = widget.model.fields[key];

          switch (value.widget.runtimeType) {
            case FormBuilderDateTimePicker:
              initialValue = initialValue != null ? config.AppSettings.dateFormat.parse(initialValue) : null;
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
            initialValue = config.AppSettings.dateFormat.format(initialValue);
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

    Map<String, dynamic> response = await widget.apiRequest.sendFormData(formData);
    Map<String, String> fieldsErrors = {};

    switch (response['statusCode']) {
      case 422:
        fieldsErrors = Map.from(response['body']['message']).map((key, value) {
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
        services.SRNotificator(context).sendMessage(
          message: widget.successMessage!,
        );
      }

      if (widget.onSuccess != null) {
        widget.onSuccess!(context, response);
      }
    } else {
      services.SRNotificator(context).sendMessage(
        message: Text(fieldsErrors.values.join('\n')),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
  }
}
