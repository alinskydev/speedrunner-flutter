import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class AuthRegister extends base.View {
  AuthRegister({Key? key}) : super(key: key);

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: widgets.NetworkForm(
            model: models.AuthRegister(),
            network: services.AppNetwork(
              uri: Uri(path: 'auth/signup'),
            ),
            onSuccess: (context, response) async {
              await base.Singletons.user.login(response.data['access_token']);

              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(builder: (context) => views.ProfileView()),
                (route) => false,
              );

              services.AppNotificator(context).sendMessage('You have been registered');
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
                    name: 'email',
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(height: 30),
                  FormBuilderTextField(
                    name: 'full_name',
                    decoration: InputDecoration(
                      labelText: 'Full name',
                    ),
                  ),
                  SizedBox(height: 30),
                  FormBuilderTextField(
                    name: 'phone',
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone',
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
                  FormBuilderTextField(
                    name: 'confirm_password',
                    obscureText: _isConfirmPasswordHidden,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                        }),
                        icon: Icon(_isConfirmPasswordHidden ? Icons.remove_red_eye : Icons.hide_image),
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
        current: widgets.AppNavBottomTabs.register,
      ),
    );
  }
}
