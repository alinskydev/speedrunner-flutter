import 'dart:convert';
import 'dart:async';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;

class AppCart {
  Map<String, Map> products = {};
  int quantity = 0;
  int price = 0;

  StreamController<Map> controller = StreamController<Map>.broadcast();

  Map<String, dynamic> get data {
    return {
      'products': products,
      'quantity': quantity,
      'price': price,
    };
  }

  AppCart._init();

  static Future<AppCart> init() async {
    String? storageDataJson = await base.Singletons.sharedStorage.getData('cart', String);
    Map<String, dynamic> storageDataMap = storageDataJson != null ? jsonDecode(storageDataJson) : {};

    AppCart instance = AppCart._init();
    if (storageDataMap.isNotEmpty) instance.changeAll(storageDataMap);

    return instance;
  }

  void change({
    required models.Product product,
    required int quantity,
  }) {
    String id = product.getValue('id');
    product.cartQuantity = quantity >= 0 ? quantity : 9;

    if (quantity > 0) {
      products[id] = product.fields[base.ModelFieldType.all]!;
      products[id]!['cartQuantity'] = quantity;
    } else {
      products.remove(id);
    }

    _save();
  }

  void changeAll(Map<String, dynamic> data) {
    products = Map<String, Map<String, dynamic>>.from(data['products'] ?? {});
    quantity = data['quantity'] ?? 0;
    price = data['price'] ?? 0;

    _save();
  }

  void clear() => changeAll({});

  int getProductQuantity({
    required models.Product product,
  }) {
    String id = product.getValue('id');
    return products[id]?['cartQuantity'] ?? 0;
  }

  Future<void> _save() async {
    Iterable<int> quantities = products.values.map<int>((e) => e['cartQuantity']);
    Iterable<int> prices = products.values.map<int>((e) => e['cartQuantity'] * e['price']);

    quantity = quantities.isNotEmpty ? quantities.reduce((value, element) => value + element) : 0;
    price = prices.isNotEmpty ? prices.reduce((value, element) => value + element) : 0;

    await base.Singletons.sharedStorage.setData('cart', jsonEncode(data));

    controller.add(data);
  }
}
