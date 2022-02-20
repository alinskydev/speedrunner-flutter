import 'dart:convert';

import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;

class Cart {
  static int quantity = 0;
  static Map<String, Map<String, dynamic>> products = {};

  static void changeAll(Map<String, dynamic> data) {
    quantity = data['quantity'] ?? 0;
    products = Map<String, Map<String, dynamic>>.from(data['products'] ?? {});
  }

  static int getQuantity({
    required models.Product product,
  }) {
    String id = product.getValue('id');
    return products[id]?['cartQuantity'] ?? 0;
  }

  static void change({
    required models.Product product,
    required int quantity,
  }) {
    String id = product.getValue('id');

    if (quantity > 0) {
      products[id] = product.fields;
      products[id]!['cartQuantity'] = quantity;
      product.cartQuantity = quantity;
    } else {
      products.remove(id);
    }

    save();
  }

  static Future<void> save() async {
    List<int> quantities = products.values.map((e) => e['cartQuantity'] as int).toList();

    Map<String, dynamic> data = {
      'quantity': quantities.reduce((value, element) => value + element),
      'products': products,
    };

    await services.SRSharedStorage().setData(
      'cart',
      jsonEncode(data),
    );
  }
}
