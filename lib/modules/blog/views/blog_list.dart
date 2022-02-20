import 'package:flutter/cupertino.dart';
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
                CupertinoPageRoute(builder: (context) => views.BlogCreate()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => bloc.SRLazyLoadCubit()),
          BlocProvider(create: (context) => bloc.BlogActionButtonsAnimationCubit()),
        ],
        child: widgets.SRLazyLoad(
          type: widgets.SRLazyLoadType.gridView,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 0.7,
          ),
          prepend: Column(
            children: [
              Text('Blogs page', style: Theme.of(context).textTheme.headline2),
            ],
          ),
          emptyChild: Text(
            'Nothing found zzz',
            style: Theme.of(context).textTheme.headline1,
          ),
          apiRequest: services.SRApiRequest(
            path: 'blog',
            queryParameters: {
              'sort': 'id',
              'per-page': '2',
            },
          ),
          builder: (context, records) {
            return records.map((e) {
              models.Blog blog = models.Blog(e);

              return GestureDetector(
                onTap: () {
                  context.read<bloc.BlogActionButtonsAnimationCubit>().process(blog.getStrictValue('id'));
                },
                child: widgets.SRReplacer(
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
                                  tag: 'hero-blog-${blog.getValue('id')}',
                                  child: services.SRImage(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                  ).renderNetwork(
                                    url: blog.getValue('image'),
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
                                blog.getValue('name'),
                                style: Theme.of(context).textTheme.headline4,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                blog.getValue('slug'),
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
