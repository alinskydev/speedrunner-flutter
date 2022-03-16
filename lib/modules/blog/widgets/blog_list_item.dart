import 'package:flutter/material.dart';

import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class BlogListItem extends StatefulWidget {
  models.Blog model;

  BlogListItem({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _BlogListItemState createState() => _BlogListItemState();
}

class _BlogListItemState extends State<BlogListItem> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = Tween(begin: 100.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        animationController.isCompleted ? animationController.reverse() : animationController.forward();
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
                    tag: 'hero-blog-${widget.model.getValue('id')}',
                    child: services.AppImage(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                    ).renderNetwork(
                      url: widget.model.getValue('image'),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(animation.value, 0),
                        child: widgets.BlogListActionButtons(
                          model: widget.model,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.model.getValue('slug'),
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.model.getValue('short_description'),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
