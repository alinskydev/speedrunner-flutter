import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class BlogList extends StatelessWidget {
  const BlogList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => widgets.LazyLoadCubit()),
        BlocProvider(create: (context) => bloc.BlogActionButtonsAnimationCubit()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blogs'),
          centerTitle: true,
        ),
        body: widgets.LazyLoad(
          apiRequest: services.ApiRequest(
            path: 'blog',
            queryParameters: {
              'sort': 'id',
              'per-page': '2',
            },
          ),
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
              models.Blog blog = models.Blog.fromMap(e);

              return GestureDetector(
                onTap: () {
                  context.read<bloc.BlogActionButtonsAnimationCubit>().process(blog.fields['id']);
                },
                child: Container(
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
                              child: services.Image.renderNetwork(
                                url: blog.fields['image'],
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                              ),
                            ),
                            widgets.BlogActionButtons(model: blog),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${blog.localizedFields['name']}',
                            style: Theme.of(context).textTheme.headline4,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${blog.localizedFields['short_description']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList();
          },
        ),
        bottomNavigationBar: widgets.Scaffold.bottomNavigationBar(context, 1),
      ),
    );
  }
}
