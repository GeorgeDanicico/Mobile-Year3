import 'package:flutter/material.dart';
import 'package:flutter_app/service/ProductService.dart';
import 'package:provider/provider.dart';

import '../model/Product.dart';
import 'add.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        body: FutureBuilder<List<Product>?>(
          future: Provider.of<ProductService>(context).getAllElements(),
          builder: ((context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  Product? product = snapshot.data?[index];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                            'Product Name: ${product?.productName}   Serial Number: ${product?.serialNumber}'),
                        subtitle: Text(
                            'Price: ${product?.price.toStringAsFixed(2)}   Quantity: ${product?.quantity}   Aisle: ${product?.aisle}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('EDIT'),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AddWidget(editProduct: product);
                              }));
                            },
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            child: const Text('DELETE'),
                            onPressed: () {
                              _dialogBuilder(context, product);
                            },
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
        ));
  }

  Future<void> _dialogBuilder(BuildContext context, Product? product) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('You are about to delete a product.\n'
              'Do you wish to continue?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Provider.of<ProductService>(context, listen: false)
                    .deleteProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
