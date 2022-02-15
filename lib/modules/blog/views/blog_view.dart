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
        title: Text(model.localizedFields['name']),
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
                  tag: 'hero-blog-${model.fields['id']}',
                  child: services.Image.renderNetwork(
                    url: model.fields['image'],
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
                Text(model.localizedFields['name'], style: Theme.of(context).textTheme.headline4),
                SizedBox(height: 30),
                Text(model.localizedFields['short_description']),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widgets.NavBottom(
        currentName: 'blog',
      ),
    );
  }
}
