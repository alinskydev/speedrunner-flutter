import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class BlogList extends base.View {
  BlogList({Key? key}) : super(key: key);

  @override
  State<BlogList> createState() => _BlogListState();
}

class _BlogListState extends State<BlogList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blogs'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => views.BlogCreate()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: widgets.InfiniteScroll(
        type: widgets.InfiniteScrollType.gridView,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 0.7,
        ),
        prepend: Column(
          children: [
            Text('Blogs page', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        noData: widgets.AppNoData(
          type: widgets.AppNoDataTypes.blog,
        ),
        network: services.AppNetwork(
          uri: Uri(
            path: 'blog',
            queryParameters: {
              'sort': 'id',
              'per-page': '2',
            },
          ),
        ),
        builder: (context, records) {
          return records.map((e) {
            return widgets.BlogListItem(
              model: models.Blog(e),
            );
          }).toList();
        },
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        current: widgets.AppNavBottomTabs.blog,
      ),
    );
  }
}
