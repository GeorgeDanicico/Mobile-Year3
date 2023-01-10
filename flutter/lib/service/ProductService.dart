import 'package:flutter/material.dart';
import 'package:flutter_app/model/Product.dart';
import 'package:flutter_app/repo/DBRepo.dart';
import 'package:flutter_app/repo/InMemoryRepo.dart';
import 'package:flutter_app/repo/Repository.dart';

class ProductService extends ChangeNotifier {
  ServerRepository _repository;

  ProductService(this._repository);

  Future<bool> addProduct(Product product) async {
    bool isValid = await _repository.add(product);

    if (isValid == true) notifyListeners();

    return isValid;
  }

  Future<List<Product>> getAllElements() {
    return _repository.getAll();
  }

  Future<bool> deleteProduct(Product? product) async {
    bool returnValue = await _repository.delete(product);

    notifyListeners();

    return returnValue;
  }

  Product getElement(int index) {
    return _repository.get(index);
  }

  Future<bool> editProduct(Product newProduct, Product? oldProduct) async {
    bool valid = true;
    if (oldProduct != null) {
      valid = await _repository.edit(newProduct, oldProduct);
    }

    if (valid != false) notifyListeners();

    return valid;
  }
}
