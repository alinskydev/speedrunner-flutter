import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class CartActionButtons extends StatefulWidget {
  models.Product model;

  CartActionButtons({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<CartActionButtons> createState() => _CartActionButtonsState();
}

class _CartActionButtonsState extends State<CartActionButtons> {
  @override
  Widget build(BuildContext context) {
    if (widget.model.cartQuantity > 0) {
      return Flexible(
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
      );
    } else {
      return Flexible(
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
      );
    }
  }
}
