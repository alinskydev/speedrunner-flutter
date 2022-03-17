import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class BlogView extends base.View {
  models.Blog model;

  BlogView({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.getValue('name')),
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
                  tag: 'hero-blog-${widget.model.getValue('id')}',
                  child: services.Image(
                    width: MediaQuery.of(context).size.width / 2,
                  ).renderNetwork(
                    url: widget.model.getValue('image'),
                  ),
                ),
                Text(widget.model.getValue('name'), style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 30),
                Text(widget.model.getValue('short_description')),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        current: widgets.AppNavBottomTabs.blog,
      ),
    );
  }
}
