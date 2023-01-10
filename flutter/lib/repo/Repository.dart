import '../model/Product.dart';

abstract class Repository {
  void fetchProducts();
  bool add(Product product);
  bool insert(Product product, int index);
  bool delete(Product? product);
  bool edit(Product newProduct, Product? oldProduct);
  Product get(int index);
  getAll();
}
