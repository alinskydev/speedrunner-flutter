import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;

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
                      base.Singletons.cart.change(
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
                      base.Singletons.cart.change(
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
                  base.Singletons.cart.change(
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
            base.Singletons.cart.change(
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
