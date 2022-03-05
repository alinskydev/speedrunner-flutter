import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/views.dart' as views;
import '/libraries/widgets.dart' as widgets;

class BlogListActionButtons extends StatelessWidget {
  models.Blog model;

  BlogListActionButtons({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 1),
            left: BorderSide(color: Colors.black, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(-3, 3),
              blurRadius: 3,
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => views.BlogView(model: model)),
                );
              },
              icon: Icon(Icons.remove_red_eye),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => views.BlogUpdate(model: model)),
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
