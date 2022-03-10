import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/base.dart' as base;
import '/libraries/config.dart' as config;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class BlogCreate extends base.StatelessView {
  models.Blog model = models.Blog();

  BlogCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BlogForm(
      title: 'Create',
      model: model,
      apiRequest: services.AppNetwork(
        path: 'blog/create',
      ),
    );
  }
}

class BlogUpdate extends base.StatelessView {
  models.Blog model;

  BlogUpdate({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BlogForm(
      title: 'Update: ${model.getValue('name')}',
      model: model,
      apiRequest: services.AppNetwork(
        path: 'blog/update/${model.getValue('id')}',
      ),
    );
  }
}

class _BlogForm extends StatelessWidget {
  String title;
  models.Blog model;
  services.AppNetwork apiRequest;

  List<String> images = [];

  _BlogForm({
    Key? key,
    required this.title,
    required this.model,
    required this.apiRequest,
  }) : super(key: key) {
    if (model.getValue('images', asString: false) != null) {
      images = List<String>.from(model.getValue('images', asString: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => widgets.AppLiveSearchSelectCubit()),
        ],
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: widgets.AppNetworkForm(
              model: model,
              apiRequest: apiRequest,
              successMessage: 'Successfully saved',
              onSuccess: (context, response) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => views.BlogList(),
                  ),
                );
              },
              builder: (context, formState) {
                return Column(
                  children: [
                    FormBuilderTextField(
                      name: 'slug',
                      decoration: InputDecoration(
                        labelText: 'Slug',
                        hintText: 'Slug placeholder',
                        prefixIcon: Icon(Icons.link),
                        suffixIcon: IconButton(
                          onPressed: () => formState.formKey.currentState?.fields['slug']?.reset(),
                          icon: Icon(Icons.clear, color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    FormBuilderDateTimePicker(
                      name: 'published_at',
                      decoration: InputDecoration(
                        labelText: 'Published at',
                        hintText: DateTime.now().toString(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      format: config.AppSettings.dateFormat,
                      alwaysUse24HourFormat: true,
                      inputType: InputType.both,
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      initialValue: model.category?.getValue('name'),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onTap: () {
                        context.read<widgets.AppLiveSearchSelectCubit>().process(
                              apiRequest: services.AppNetwork(path: 'blog-category'),
                            );
                      },
                      onChanged: (value) {
                        context.read<widgets.AppLiveSearchSelectCubit>().process(
                              apiRequest: services.AppNetwork(
                                path: 'blog-category',
                                queryParameters: {
                                  'filter[name]': value,
                                },
                              ),
                            );
                      },
                    ),
                    widgets.AppLiveSearchSelect(
                      valuePath: 'id',
                      textPath: 'name',
                      isLocalized: true,
                      builder: (context, options) {
                        return FormBuilderChoiceChip(
                          name: 'category_id',
                          options: options,
                        );
                      },
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: images.map((element) {
                            return widgets.AppReplacer(
                              builder: (context, replacerState) {
                                return Row(
                                  children: [
                                    Stack(
                                      children: [
                                        services.AppImage(
                                          height: 200,
                                        ).renderNetwork(
                                          url: element,
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
                                                  path: 'blog/file-delete/${model.getValue('id')}',
                                                  queryParameters: {
                                                    'attr': 'images',
                                                  },
                                                ).sendRequest(
                                                  method: services.AppNetworkMethods.post,
                                                  data: {
                                                    'key': services.AppImage.trimApiUrl(element),
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
                                    SizedBox(width: 20),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    FormBuilderFilePicker(
                      name: 'images',
                      allowMultiple: true,
                      decoration: InputDecoration(
                        labelText: 'Attachments',
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
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        currentName: 'blog',
      ),
    );
  }
}
