import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class AuthLogin extends StatefulWidget {
  AuthLogin({Key? key}) : super(key: key);

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  bool _isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: widgets.ApiForm(
            model: models.AuthLogin(),
            apiRequest: services.ApiRequest(
              path: 'auth/login',
            ),
            onSuccess: (context, response) async {
              await base.User.login(response['body']['access_token']);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => views.ProfileView()),
                (route) => false,
              );
            },
            builder: (context, formState) {
              return Column(
                children: [
                  FormBuilderTextField(
                    name: 'username',
                    decoration: InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  SizedBox(height: 30),
                  FormBuilderTextField(
                    name: 'password',
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        }),
                        icon: Icon(_isPasswordHidden ? Icons.remove_red_eye : Icons.hide_image),
                      ),
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
        currentName: 'login',
      ),
    );
  }
}
