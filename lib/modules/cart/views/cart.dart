import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/widgets.dart' as widgets;

class Cart extends base.StatelessView {
  Cart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: base.Singletons.cart.controller.stream,
        initialData: base.Singletons.cart.data,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return SizedBox.shrink();

          Map<String, dynamic> cartData = snapshot.data as Map<String, dynamic>;
          List<Map<String, dynamic>> products = cartData['products'].values.toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                cartData['quantity'] > 0
                    ? ElevatedButton(
                        onPressed: () {
                          base.Singletons.cart.clear();
                        },
                        child: Text('Clear'),
                      )
                    : SizedBox.shrink(),
                cartData['quantity'] > 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          models.Product product = models.Product(products[index]);

                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    child: ListTile(
                                      title: Text(product.getValue('slug')),
                                      subtitle: Text(product.getValue('price')),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 3,
                                  height: 100,
                                  child: widgets.CartActionButtons(
                                    model: product,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : widgets.AppNoData(
                        type: widgets.AppNoDataTypes.cart,
                      ),
                Text('Total price: ${cartData['price']} (x${cartData['quantity']})', style: TextStyle(fontSize: 30)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        currentName: 'cart',
      ),
    );
  }
}
