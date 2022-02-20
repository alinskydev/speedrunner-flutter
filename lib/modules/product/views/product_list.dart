import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '/libraries/base.dart' as base;
import '/libraries/bloc.dart' as bloc;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class ProductList extends StatelessWidget {
  List<models.Product> products = [
    models.Product({
      'id': 1,
      'slug': 'One',
    }),
    models.Product({
      'id': 2,
      'slug': 'Two',
    }),
    models.Product({
      'id': 3,
      'slug': 'Three',
    }),
  ];

  ProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          models.Product product = products[index];

          TextStyle _buttonsStyle = TextStyle(
            fontWeight: FontWeight.bold,
            height: 1,
          );

          return Container(
            height: 60,
            padding: EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    services.Cart.change(
                      product: product,
                      quantity: 1,
                    );
                  },
                  child: Text('Add', style: _buttonsStyle),
                  style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                        backgroundColor: MaterialStateProperty.all(Colors.green),
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    services.Cart.change(
                      product: product,
                      quantity: product.cartQuantity - 1,
                    );
                  },
                  child: Text('-', style: _buttonsStyle),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    product.cartQuantity.toString(),
                    style: _buttonsStyle,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    services.Cart.change(
                      product: product,
                      quantity: product.cartQuantity + 1,
                    );
                  },
                  child: Text('+', style: _buttonsStyle),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.error),
                  ),
                  onPressed: () {
                    services.Cart.change(
                      product: product,
                      quantity: 0,
                    );
                  },
                  child: Text('x', style: _buttonsStyle),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        currentName: 'product',
      ),
    );
  }
}
