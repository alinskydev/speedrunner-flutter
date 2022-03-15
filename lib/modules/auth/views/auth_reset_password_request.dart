import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class AuthResetPasswordRequest extends base.View {
  AuthResetPasswordRequest({Key? key}) : super(key: key);

  @override
  State<AuthResetPasswordRequest> createState() => _AuthResetPasswordRequestState();
}

class _AuthResetPasswordRequestState extends State<AuthResetPasswordRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset password request page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: widgets.AppNetworkForm(
            model: models.AuthResetPasswordRequest(),
            apiRequest: services.AppNetwork(
              path: 'auth/reset-password-request',
            ),
            successMessage: 'Message was sent to your email',
            onSuccess: (context, response) async {
              Navigator.pop(context);
            },
            builder: (context, formState) {
              return Column(
                children: [
                  FormBuilderTextField(
                    name: 'email',
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => formState.validate(),
                      child: Text('Submit'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        currentName: 'reset_password_request',
      ),
    );
  }
}
