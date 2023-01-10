import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app/db/Database.dart';
import 'package:flutter_app/model/Product.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ServerRepository {
  List<Product> products = [];
  // The local db that will be used.
  DatabaseProvider dbProvider = DatabaseProvider.db;
  late StreamSubscription networkSubscription;
  Queue<String> offlineOperationsQueue = Queue();
  Queue<Product> offlineObjectsQueue = Queue();
  late WebSocketChannel channel;
  late WebSocket ws;

  ServerRepository() {
    dbProvider.initDB();
    initializeWebSocket();

    networkSubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        print("LOG: Phone not connected to the internet");
      } else {
        print("LOG: Phone connected to the internet");
        while (offlineObjectsQueue.isNotEmpty &&
            result != ConnectivityResult.none) {
          String operation = offlineOperationsQueue.first;
          Product product = offlineObjectsQueue.first;

          if (operation == "ADD") {
            addOffline(product);
          }
          if (operation == "EDIT") {
            editOffline(product);
          }
          if (operation == "DELETE") {
            deleteOffline(product);
          }
          offlineObjectsQueue.removeFirst();
          offlineOperationsQueue.removeFirst();
        }
      }
    });
  }

  void initializeWebSocket() async {
    // ws = await WebSocket.connect('ws://192.168.0.108:8080/app');
    // ws.listen((event) {
    //   print(event);
    // });

    channel =
        WebSocketChannel.connect(Uri.parse('ws://192.168.0.108:8080/app'));
    channel.stream.listen((data) {
      print("Received message from server: $data");
    });
  }

  Future<List<Product>> fetchProducts() async {
    // the products that are stored locally.
    List<Product> initialProducts = await dbProvider.getAllProducts();

    // the products that are store on the server.
    try {
      Response response = await http.get(Uri.parse('${Utils.path}/api/all'));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> serverList = jsonDecode(response.body);
        List<Product> serverListDecoded = [];

        for (int i = 0; i < serverList.length; i++) {
          serverListDecoded.add(Product.fromJson(serverList[i]));
        }

        for (int i = 0; i < serverList.length; i++) {
          if (!contains(initialProducts, serverListDecoded[i])) {
            dbProvider.insertProductFromServer(serverListDecoded[i]);
          }
        }

        return serverListDecoded;
      }
    } catch (e) {
      print("LOG: The server is offline (fetchProducts)");
    }

    return initialProducts;
  }

  Future<bool> add(Product product) async {
    int id = await dbProvider.insertProduct(product);
    if (id != -1) {
      product.id = id;
      products.add(product);

      try {
        final data = product.toJson();

        Response response = await http.post(Uri.parse('${Utils.path}/api/add'),
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        offlineOperationsQueue.add("ADD");
        offlineObjectsQueue.add(product);
        print("LOG: The server is offline (add)");
      }

      return true;
    }

    return false;
  }

  Future<bool> delete(Product? product) async {
    if (product != null) {
      dbProvider.deleteProduct(product);
      int? deletedId = product.id;
      products.remove(product);

      try {
        Response response =
            await http.delete(Uri.parse('${Utils.path}/api/delete/$deletedId'));
      } catch (e) {
        offlineOperationsQueue.add("DELETE");
        offlineObjectsQueue.add(product);
        print("LOG: The server is offline. (delete)");
      }

      return true;
    }

    return false;
  }

  Future<bool> edit(Product newProduct, Product? oldProduct) async {
    if (oldProduct != null) {
      newProduct.id = oldProduct.id;
      int id = await dbProvider.updateProduct(newProduct);
      if (id == -1) return false;
      int index = products.indexOf(oldProduct);
      products[index] = newProduct;

      final data = newProduct.toJson();
      try {
        Response response = await http.put(Uri.parse('${Utils.path}/api/edit'),
            body: jsonEncode(data),
            headers: {'Content-Type': 'application/json'});
      } catch (e) {
        offlineOperationsQueue.add("EDIT");
        offlineObjectsQueue.add(newProduct);
        print("LOG: The server is offline. (edit)");
      }
    }

    return true;
  }

  Product get(int index) {
    return products[index];
  }

  Future<List<Product>> getAll() async {
    if (products.isEmpty) {
      products = await fetchProducts();
      print("This is the list: $products");
    }

    return products;
  }

  Future<bool> addOffline(Product product) async {
    try {
      final data = product.toJson();

      Response response = await http.post(Uri.parse('${Utils.path}/api/add'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      return true;
    } catch (e) {
      offlineOperationsQueue.add("ADD");
      offlineObjectsQueue.add(product);
      print("LOG: The server is offline (add)");

      return false;
    }
  }

  Future<bool> deleteOffline(Product product) async {
    try {
      Response response = await http
          .delete(Uri.parse('${Utils.path}/api/delete/${product.id}'));

      return true;
    } catch (e) {
      offlineOperationsQueue.add("DELETE");
      offlineObjectsQueue.add(product);
      print("LOG: The server is offline. (delete)");

      return false;
    }
  }

  Future<bool> editOffline(Product product) async {
    final data = product.toJson();
    try {
      Response response = await http.put(Uri.parse('${Utils.path}/api/edit'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      return true;
    } catch (e) {
      offlineOperationsQueue.add("EDIT");
      offlineObjectsQueue.add(product);
      print("LOG: The server is offline. (edit)");

      return false;
    }
  }

  bool contains(List<Product> l, Product p) {
    for (int i = 0; i < l.length; i++) {
      if (l[i].id == p.id) {
        return true;
      }
    }

    return false;
  }
}
