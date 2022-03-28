import '/core/base/model.dart';

import '/libraries/base.dart' as base;

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
    cartQuantity = base.Singletons.cart.getProductQuantity(product: this);
  }
}
