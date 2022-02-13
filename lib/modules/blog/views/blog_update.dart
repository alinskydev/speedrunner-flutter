import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

import '/base/config.dart' as config;

class BlogUpdate extends StatelessWidget {
  models.Blog model;

  BlogUpdate({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => widgets.LiveSearchSelectCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(model.localizedFields['name']),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15),
            child: widgets.ApiForm(
              model: model,
              apiRequest: services.ApiRequest(
                path: 'blog/update/${model.fields['id']}',
              ),
              builder: (context, formState) {
                print(model.fields['images']);
                List images = model.fields['images'] ?? [];

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
                      format: config.dateFormat,
                      alwaysUse24HourFormat: true,
                      inputType: InputType.both,
                    ),
                    SizedBox(height: 30),
                    TextFormField(
                      initialValue: model.category?.localizedFields['name'],
                      decoration: InputDecoration(
                        labelText: 'Category',
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onTap: () {
                        context.read<widgets.LiveSearchSelectCubit>().process(
                              apiRequest: services.ApiRequest(path: 'blog-category'),
                            );
                      },
                      onChanged: (value) {
                        context.read<widgets.LiveSearchSelectCubit>().process(
                              apiRequest: services.ApiRequest(
                                path: 'blog-category',
                                queryParameters: {
                                  'filter[name]': value,
                                },
                              ),
                            );
                      },
                    ),
                    widgets.LiveSearchSelect(
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
                            return widgets.DeletableBox(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    Stack(
                                      children: [
                                        services.Image.renderNetwork(
                                          url: element,
                                          height: 200,
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
                                              onPressed: () => state.delete(),
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
        bottomNavigationBar: widgets.Scaffold.bottomNavigationBar(context, 1),
      ),
    );
  }
}
