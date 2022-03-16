import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/plugins.dart' as plugins;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class ProfileUpdate extends base.View {
  ProfileUpdate({Key? key}) : super(key: key);

  @override
  State<ProfileUpdate> createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  Future<Map> profileFuture = services.AppNetwork(
    uri: Uri(
      path: 'profile/view',
    ),
  ).sendRequest().then((value) {
    return value.data;
  });

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile update'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: profileFuture,
            builder: (context, snapshot) {
              if (snapshot.data == null) return SizedBox.shrink();

              models.Profile model = models.Profile(snapshot.data as Map<String, dynamic>);

              return Container(
                padding: EdgeInsets.all(15),
                child: plugins.NetworkForm(
                  model: model,
                  network: services.AppNetwork(
                    uri: Uri(path: 'profile/update'),
                  ),
                  onSuccess: (context, response) async {
                    await base.Singletons.user.login(response.data['access_token']);

                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => views.ProfileView(),
                      ),
                    );

                    services.AppNotificator(context).sendMessage('Profile has been updated');
                  },
                  builder: (context, formState) {
                    return Column(
                      children: [
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
                          name: 'address',
                          minLines: 5,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Address',
                          ),
                        ),
                        plugins.Replacer(
                          builder: (context, replacerState) {
                            return model.getValue('image', asString: false) != null
                                ? Column(
                                    children: [
                                      SizedBox(height: 30),
                                      Stack(
                                        children: [
                                          SizedBox(
                                            child: services.AppImage(
                                              width: MediaQuery.of(context).size.width,
                                            ).renderNetwork(
                                              url: model.getValue('image'),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              color: Colors.red,
                                              child: MaterialButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: () async {
                                                  await services.AppNetwork(
                                                    uri: Uri(
                                                      path: 'profile/file-delete',
                                                      queryParameters: {
                                                        'attr': 'image',
                                                      },
                                                    ),
                                                  ).sendRequest(
                                                    method: services.AppNetworkMethods.post,
                                                    data: {
                                                      'key': services.AppImage.trimApiUrl(model.getValue('image')),
                                                    },
                                                  );

                                                  replacerState.process();
                                                },
                                                child: Icon(
                                                  Icons.close,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink();
                          },
                        ),
                        SizedBox(height: 30),
                        FormBuilderFilePicker(
                          name: 'image',
                          allowMultiple: false,
                          decoration: InputDecoration(
                            labelText: 'Image',
                          ),
                          selector: Container(
                            width: MediaQuery.of(context).size.width - 30,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade300,
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.file_upload),
                                Text('Upload'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        FormBuilderTextField(
                          name: 'new_password',
                          obscureText: _isPasswordHidden,
                          decoration: InputDecoration(
                            labelText: 'New password',
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
              );
            }),
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        current: widgets.AppNavBottomTabs.profile,
      ),
    );
  }
}
