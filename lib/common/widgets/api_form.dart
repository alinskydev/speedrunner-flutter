import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/base/model.dart';
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

import '/libraries/base.dart' as base;

class ApiForm extends StatefulWidget {
  Model model;
  services.ApiRequest apiRequest;
  Widget? successMessage;

  Widget Function(BuildContext context, _ApiFormState formState) builder;
  void Function(BuildContext context, Map<String, dynamic> response)? onSuccess;

  ApiForm({
    Key? key,
    required this.model,
    required this.apiRequest,
    required this.builder,
    this.successMessage,
    this.onSuccess,
  }) : super(key: key);

  @override
  _ApiFormState createState() => _ApiFormState();
}

class _ApiFormState extends State<ApiForm> {
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
              initialValue = initialValue != null ? base.Config.dateFormat.parse(initialValue) : null;
              break;
            case FormBuilderFilePicker:
              initialValue = List<PlatformFile>.from([]);
              break;
            default:
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
            initialValue = base.Config.dateFormat.format(initialValue);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: EdgeInsets.all(15),
            backgroundColor: Colors.green,
            content: Container(
              child: widget.successMessage,
            ),
          ),
        );
      }

      if (widget.onSuccess != null) {
        widget.onSuccess!(context, response);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: EdgeInsets.all(15),
          backgroundColor: Colors.red,
          content: Text(fieldsErrors.values.join('\n')),
        ),
      );
    }
  }
}
