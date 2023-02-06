import '../model/Entity.dart';

abstract class Repository {
  void fetchProducts();
  bool add(Entity product);
  bool insert(Entity product, int index);
  bool delete(Entity? product);
  bool edit(Entity newProduct, Entity? oldProduct);
  Entity get(int index);
  getAll();
}
