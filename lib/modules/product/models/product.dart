import '/base/model.dart';

import '/libraries/services.dart' as services;

class Product extends Model {
  @override
  Map<ModelFieldType, List> availableFields = {
    ModelFieldType.all: [
      'id',
      'name',
      'slug',
      'price',
    ],
    ModelFieldType.localized: [
      'name',
    ],
  };

  int cartQuantity = 0;

  Product([Map<String, dynamic> map = const {}]) : super(map) {
    cartQuantity = services.Cart.getProductQuantity(product: this);
  }
}
