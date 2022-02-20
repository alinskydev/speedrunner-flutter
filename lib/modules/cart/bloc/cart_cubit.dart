import 'package:flutter_bloc/flutter_bloc.dart';

import '/libraries/services.dart' as services;

class CartCubit extends Cubit<int> {
  CartCubit() : super(0);

  Future<void> process(int quantity) async {
    emit(quantity);
  }
}
