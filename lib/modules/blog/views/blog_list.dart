import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class BlogList extends StatelessWidget {
  BlogList({Key? key}) : super(key: key);

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
                MaterialPageRoute(builder: (context) => views.BlogCreate()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => widgets.LazyLoadCubit()),
          BlocProvider(create: (context) => bloc.BlogActionButtonsAnimationCubit()),
        ],
        child: widgets.LazyLoad(
          apiRequest: services.ApiRequest(
            path: 'blog',
            queryParameters: {
              'sort': 'id',
              'per-page': '2',
            },
          ),
          type: widgets.LazyLoadType.gridView,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 0.7,
          ),
          prepend: Column(
            children: [
              Text('Blogs page', style: Theme.of(context).textTheme.headline2),
            ],
          ),
          builder: (context, records) {
            return records.map((e) {
              models.Blog blog = models.Blog(e);

              return GestureDetector(
                onTap: () {
                  context.read<bloc.BlogActionButtonsAnimationCubit>().process(blog.fields['id']);
                },
                child: widgets.Replacer(
                  builder: (context, replacerState) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Hero(
                                  tag: 'hero-blog-${blog.fields['id']}',
                                  child: services.Image(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                  ).renderNetwork(
                                    url: blog.fields['image'],
                                  ),
                                ),
                                widgets.BlogActionButtons(
                                  model: blog,
                                  replacerState: replacerState,
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                blog.localizedFields['name'] ?? '',
                                style: Theme.of(context).textTheme.headline4,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                blog.fields['slug'] ?? '',
                                style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
