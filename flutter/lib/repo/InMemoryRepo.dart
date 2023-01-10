import 'package:flutter/material.dart';
import 'package:flutter_app/model/Product.dart';
import 'package:flutter_app/repo/Repository.dart';

class InMemoryRepository implements Repository {
  var products = [
    Product.withoutLocation(1, "12345ab", "Product 1", "Tech", 12.00, 12),
    Product.withoutLocation(2, "12345ab", "Product 2", "Tech", 12.00, 12),
    Product.withoutLocation(3, "12345ab", "Product 3", "Tech", 12.00, 12),
  ];

  @override
  bool add(Product product) {
    products.add(product);

    return true;
  }

  @override
  Product get(int index) {
    return products[index];
  }

  @override
  bool insert(Product product, int index) {
    products.insert(index, product);

    return true;
  }

  @override
  bool delete(Product? product) {
    products.remove(product);

    return true;
  }

  @override
  bool edit(Product newProduct, Product? oldProduct) {
    int index = oldProduct != null ? products.indexOf(oldProduct) : -1;

    if (index != -1) {
      products.remove(oldProduct);
      products.insert(index, newProduct);
    }

    return true;
  }

  @override
  getAll() {
    return products;
  }

  @override
  void fetchProducts() {
    // TODO: implement fetchProducts
  }
}
