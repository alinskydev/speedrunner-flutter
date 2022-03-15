import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/libraries/base.dart' as base;
import '/libraries/bloc.dart' as bloc;
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
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => bloc.AppLazyLoadCubit()),
        ],
        child: widgets.AppLazyLoad(
          type: widgets.AppLazyLoadType.gridView,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 0.7,
          ),
          prepend: Column(
            children: [
              Text('Blogs page', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          noDataChild: widgets.AppNoData(
            type: widgets.AppNoDataTypes.blog,
          ),
          apiRequest: services.AppNetwork(
            path: 'blog',
            queryParameters: {
              'sort': 'id',
              'per-page': '2',
            },
          ),
          builder: (context, records) {
            return records.map((e) {
              return widgets.BlogListItem(
                model: models.Blog(e),
              );
            }).toList();
          },
        ),
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        currentName: 'blog',
      ),
    );
  }
}
