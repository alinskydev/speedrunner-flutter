import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/libraries/base.dart' as base;
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
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
            services.Cart.clear();
          },
          child: Text('View'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
      ),
    ];

    if (widget.model.cartQuantity > 0) {
      actionButtons.add(
        Flexible(
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        services.Cart.change(
                          product: widget.model,
                          quantity: widget.model.cartQuantity + 1,
                        );

                        setState(() {});
                      },
                      child: Text('+'),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.yellowAccent,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.model.cartQuantity.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        services.Cart.change(
                          product: widget.model,
                          quantity: widget.model.cartQuantity - 1,
                        );

                        setState(() {});
                      },
                      child: Text('-'),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: ElevatedButton(
                  onPressed: () {
                    services.Cart.change(
                      product: widget.model,
                      quantity: 0,
                    );

                    setState(() {});
                  },
                  child: Text('x'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      actionButtons.add(
        Flexible(
          fit: FlexFit.tight,
          child: ElevatedButton(
            onPressed: () {
              services.Cart.change(
                product: widget.model,
                quantity: 1,
              );

              setState(() {});
            },
            child: Text('Add'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
            ),
          ),
        ),
      );
    }

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
        child: widgets.SRSlidableChecker(
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
