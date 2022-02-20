import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class BlogView extends StatelessWidget {
  models.Blog model;

  BlogView({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(model.getValue('name')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Hero(
                  tag: 'hero-blog-${model.getValue('id')}',
                  child: services.SRImage(
                    width: MediaQuery.of(context).size.width / 2,
                  ).renderNetwork(
                    url: model.getValue('image'),
                  ),
                ),
                Text(model.getValue('name'), style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 30),
                Text(model.getValue('short_description')),
              ],
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
