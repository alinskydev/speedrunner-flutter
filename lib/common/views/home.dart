import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class Home extends StatelessWidget {
  Future<Map> blocksFuture = services.ApiRequest(
    path: 'staticpage/home',
  ).getData().then((value) {
    return Map.fromIterable(
      value['body']['blocks'],
      key: (element) => element['name'],
      value: (element) => element['value'],
    );
  });

  Future<List> blogsFuture = services.ApiRequest(
    path: 'blog',
    queryParameters: {
      'per-page': '2',
    },
  ).getData().then((value) {
    return value['body']['data'];
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: blocksFuture,
              builder: (context, snapshot) {
                if (snapshot.data == null) return Container();

                Map blocks = snapshot.data as Map;

                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 200,
                          viewportFraction: 0.9,
                        ),
                        items: List<Map>.from(blocks['slider']).map((e) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: services.Image.renderNetwork(
                                  url: e['image'],
                                  isAbsolute: false,
                                  width: MediaQuery.of(context).size.width,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Divider(height: 30, color: Colors.black),
                      Text(blocks['about_title'], style: Theme.of(context).textTheme.headline2),
                      SizedBox(height: 10),
                      Text(blocks['about_description'], style: Theme.of(context).textTheme.subtitle1),
                      Divider(height: 30, color: Colors.black),
                    ],
                  ),
                );
              },
            ),
            FutureBuilder(
              future: blogsFuture,
              builder: (context, snapshot) {
                if (snapshot.data == null) return Container();

                List records = snapshot.data as List;

                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    models.Blog blog = models.Blog.fromMap(records[index]);

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            services.Image.renderNetwork(
                              url: blog.fields['image'],
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                '${blog.localizedFields['name']}',
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
                    );
                  },
                );
              },
            ),
            FutureBuilder(
              future: blocksFuture,
              builder: (context, snapshot) {
                if (snapshot.data == null) return Container();

                Map blocks = snapshot.data as Map;

                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 30, color: Colors.black),
                      services.Image.renderNetwork(
                        url: blocks['banner'],
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: widgets.Scaffold.bottomNavigationBar(context, 0),
    );
  }
}
