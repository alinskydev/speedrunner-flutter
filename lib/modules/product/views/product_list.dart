import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;
import '/libraries/widgets.dart' as widgets;

class ProductList extends base.View {
  ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<models.Product> products = [
    models.Product({
      'id': 1,
      'slug': 'One',
      'price': 100,
    }),
    models.Product({
      'id': 2,
      'slug': 'Two',
      'price': 200,
    }),
    models.Product({
      'id': 3,
      'slug': 'Three',
      'price': 400,
    }),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => widgets.ProductListIem(model: products[index]),
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        currentName: 'product',
      ),
    );
  }
}
