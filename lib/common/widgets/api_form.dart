import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/base/model.dart';
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

import '/base/config.dart' as config;

class ApiForm extends StatefulWidget {
  Model model;
  services.ApiRequest apiRequest;

  Widget Function(BuildContext context, _ApiFormState formStates) builder;

  ApiForm({
    Key? key,
    required this.model,
    required this.apiRequest,
    required this.builder,
  }) : super(key: key);

  @override
  _ApiFormState createState() => _ApiFormState();
}

class _ApiFormState extends State<ApiForm> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey();

  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      FormBuilderState formBuilderState = formKey.currentState!;

      formBuilderState.patchValue(
        formBuilderState.fields.map((key, value) {
          var initialValue = widget.model.fields[key];

          switch (value.widget.runtimeType) {
            case FormBuilderDateTimePicker:
              initialValue = config.dateFormat.parse(initialValue);
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
            initialValue = config.dateFormat.format(initialValue);
            break;
          default:
            break;
        }
      }

      return MapEntry(key, initialValue);
    });

    Map<String, String> fieldsErrors = await widget.apiRequest.sendFormData(formData).then((value) {
      if (value['statusCode'] == 422) {
        return Map.from(value['body']['message']).map((key, value) {
          return MapEntry(key, value[0]);
        });
      }

      return {};
    });

    formKey.currentState!.validate();
    fieldsErrors.forEach((key, value) {
      formKey.currentState!.fields[key]?.invalidate(value);
    });

    if (formKey.currentState!.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          padding: EdgeInsets.all(15),
          backgroundColor: Colors.green,
          content: Container(
            child: Text('Successfully saved'),
          ),
        ),
      );
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
