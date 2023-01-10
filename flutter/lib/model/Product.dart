import 'dart:convert';

class Product {
  int? id;
  String serialNumber;
  String productName;
  String aisle;
  double price;
  int quantity;

  Product(this.serialNumber, this.productName, this.aisle, this.price,
      this.quantity);

  Product.withoutLocation(int this.id, this.serialNumber, this.productName,
      this.aisle, this.price, this.quantity);

  @override
  int get hashCode => id.hashCode;

  factory Product.fromMap(Map<String, dynamic> json) => Product.withoutLocation(
      json["id"],
      json["serial_number"],
      json["product_name"],
      json["aisle"],
      json["price"],
      json["quantity"]);

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product.withoutLocation(json["id"], json["serialNumber"],
          json["productName"], json["aisle"], json["price"], json["quantity"]);

  Map<String, dynamic> toMap() {
    return {
      'product_name': productName,
      'serial_number': serialNumber,
      'aisle': aisle,
      'quantity': quantity,
      'price': price
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'serialNumber': serialNumber,
      'aisle': aisle,
      'quantity': quantity,
      'price': price
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, product_name: $productName, serial_number: $serialNumber, '
        'aisle: $aisle, price: $price, quantity: $quantity';
  }
}

Product productFromJson(String str) {
  final jsonData = json.decode(str);
  return Product.fromMap(jsonData);
}

String productToJson(Product data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}
