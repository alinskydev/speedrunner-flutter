// ignore_for_file: prefer_for_elements_to_map_fromiterable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class AppHome extends base.View {
  AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  Future<Map> blocksFuture = services.AppNetwork(
    uri: Uri(path: 'staticpage/home'),
  ).sendRequest().then((value) {
    return Map.fromIterable(
      value.data['blocks'],
      key: (element) => element['name'],
      value: (element) => element['value'],
    );
  });

  Future<List> blogsFuture = services.AppNetwork(
    uri: Uri(
      path: 'blog',
      queryParameters: {
        'per-page': '2',
      },
    ),
  ).sendRequest().then((value) {
    return value.data['data'];
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
                if (snapshot.data == null) return SizedBox.shrink();

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
                        items: List<String>.from(blocks['slider']).map((e) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: services.AppImage(
                                  width: MediaQuery.of(context).size.width,
                                ).renderNetwork(
                                  url: e,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      Divider(height: 30, color: Colors.black),
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.headlineMedium!,
                        child: Text(blocks['about_title'] ?? ''),
                      ),
                      SizedBox(height: 10),
                      Text(blocks['about_description'] ?? ''),
                      Divider(height: 30, color: Colors.black),
                    ],
                  ),
                );
              },
            ),
            FutureBuilder(
              future: blogsFuture,
              builder: (context, snapshot) {
                if (snapshot.data == null) return SizedBox.shrink();

                List records = snapshot.data as List;

                return GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    models.Blog blog = models.Blog(records[index]);

                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            services.AppImage(
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.width / 2,
                            ).renderNetwork(
                              url: blog.getValue('image'),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                blog.getValue('name'),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                blog.getValue('short_description'),
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
                if (snapshot.data == null) return SizedBox.shrink();

                Map blocks = snapshot.data as Map;

                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 30, color: Colors.black),
                      services.AppImage(
                        width: MediaQuery.of(context).size.width,
                      ).renderNetwork(
                        url: blocks['banner'],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        current: widgets.AppNavBottomTabs.home,
      ),
    );
  }
}
