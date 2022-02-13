import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/views.dart' as views;

class BlogActionButtons extends StatefulWidget {
  models.Blog model;

  BlogActionButtons({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  _BlogActionButtonsState createState() => _BlogActionButtonsState();
}

class _BlogActionButtonsState extends State<BlogActionButtons> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = Tween(begin: 150.0, end: 0.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<bloc.BlogActionButtonsAnimationCubit, int?>(
      builder: (context, state) {
        state == widget.model.fields['id'] ? animationController.forward() : animationController.reverse();

        return AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(animation.value, 0),
              child: Align(
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
                            MaterialPageRoute(builder: (context) => views.BlogView(model: widget.model)),
                          );
                        },
                        icon: Icon(Icons.remove_red_eye),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => views.BlogUpdate(model: widget.model)),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
