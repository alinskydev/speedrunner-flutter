import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/widgets.dart' as widgets;

class ProductListIem extends StatefulWidget {
  models.Product model;

  ProductListIem({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<ProductListIem> createState() => _ProductListIemState();
}

class _ProductListIemState extends State<ProductListIem> {
  List<Widget> actionButtons = [];

  @override
  Widget build(BuildContext context) {
    actionButtons = [
      Flexible(
        fit: FlexFit.tight,
        child: ElevatedButton(
          onPressed: () {
            base.Singletons.cart.clear();
          },
          child: Text('View'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
    ];

    actionButtons.add(widgets.CartActionButtons(model: widget.model));

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.5,
          motion: BehindMotion(),
          children: [
            Flexible(
              child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: actionButtons,
              ),
            ),
          ],
        ),
        child: widgets.AppSlidableChecker(
          tag: 'productList',
          child: Container(
            height: 100,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black),
              ),
            ),
            child: ListTile(
              title: Text(widget.model.getValue('slug')),
              subtitle: Text(widget.model.getValue('price')),
            ),
          ),
        ),
      ),
    );
  }
}
