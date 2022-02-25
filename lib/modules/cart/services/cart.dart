import 'dart:convert';

import '/libraries/models.dart' as models;
import '/libraries/services.dart' as services;

class Cart {
  static Map<String, Map<String, dynamic>> products = {};

  static int quantity = 0;
  static int price = 0;

  static int getProductQuantity({
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
    product.cartQuantity = quantity >= 0 ? quantity : 9;

    if (quantity > 0) {
      products[id] = product.fields;
      products[id]!['cartQuantity'] = quantity;
    } else {
      products.remove(id);
    }

    save();
  }

  static void changeAll(Map<String, dynamic> data) {
    products = Map<String, Map<String, dynamic>>.from(data['products'] ?? {});
    quantity = data['quantity'] ?? 0;
    price = data['price'] ?? 0;
  }

  static void clear() {
    changeAll({});
    save();
  }

  static Future<void> save() async {
    Map<String, dynamic> data = {};

    if (products.isNotEmpty) {
      List<int> quantities = products.values.map((e) => e['cartQuantity'] as int).toList();
      List<int> prices = products.values.map((e) => e['cartQuantity'] * e['price'] as int).toList();

      data = {
        'products': products,
        'quantity': quantities.reduce((value, element) => value + element),
        'price': prices.reduce((value, element) => value + element),
      };
    }

    await services.SRSharedStorage().setData('cart', jsonEncode(data));
  }
}
