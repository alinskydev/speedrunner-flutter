import 'package:flutter/material.dart';

import '/libraries/base.dart' as base;
import '/libraries/models.dart' as models;
import '/libraries/widgets.dart' as widgets;

class Cart extends base.View {
  Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: base.Singletons.cart.controller.stream,
        initialData: base.Singletons.cart,
        builder: (context, snapshot) {
          List<Map<String, dynamic>> products = base.Singletons.cart.products.values.toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                base.Singletons.cart.quantity > 0
                    ? ElevatedButton(
                        onPressed: () {
                          base.Singletons.cart.clear();
                        },
                        child: Text('Clear'),
                      )
                    : SizedBox.shrink(),
                base.Singletons.cart.quantity > 0
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
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      widgets.CartActionButtons(
                                        model: product,
                                      ),
                                    ],
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
                Text(
                  'Total price: ${base.Singletons.cart.price} (x${base.Singletons.cart.quantity})',
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: widgets.AppNavBottom(
        current: widgets.AppNavBottomTabs.cart,
      ),
    );
  }
}
