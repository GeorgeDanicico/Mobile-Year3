import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_app/db/Database.dart';
import 'package:flutter_app/model/Entity.dart';
import 'package:flutter_app/model/Pair.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerRepository {
  List<String> categories = [];
  List<Entity> items = [];
  // The local db that will be used.
  DatabaseProvider dbProvider = DatabaseProvider.db;
  late StreamSubscription networkSubscription;
  bool isOnline = false;

  ServerRepository() {
    init();
  }

  void init() {
    log("Repository init()");

    dbProvider.initDB();
    _sync();
  }

  Future<void> _sync() async {
    try {
      var channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:2305'));
      channel.stream.listen((message) {
        _listenHandle(message);
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> checkOnline() async {
    bool isOnline = await InternetConnectionChecker().hasConnection;

    if (this.isOnline == false && isOnline == true) {
      await _sync();
    }

    this.isOnline = isOnline;
    return isOnline;
  }

  Future<void> _listenHandle(String data) async {
    log("websocket listen()");
    log(data);
    Entity entity = Entity.fromJson(jsonDecode(data));
    Fluttertoast.showToast(
        msg: "Movie ${entity.genre}: ${entity.name} has been added!");
  }

  Future<List<String>> fetchGenres() async {
    // the products that are stored locally.
    List<String> initialGenres = await dbProvider.getAllGenres();

    // the products that are store on the server.
    try {
      Response response = await http.get(Uri.parse('${Utils.PATH}/genres'));

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> serverList = jsonDecode(response.body);
        List<String> serverListDecoded = [];

        for (int i = 0; i < serverList.length; i++) {
          if (!initialGenres.contains(serverList[i])) {
            dbProvider.insertGenre(serverList[i]);
          }
          serverListDecoded.add(serverList[i]);
        }

        return serverListDecoded;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "No internet connection.");
      log("Error: The server is offline (fetchGenres)");
    }

    return initialGenres;
  }

  Future<List<Entity>> fetchItemsFromGenre(String? genre) async {
    // the products that are stored locally.
    List<Entity> initialItems = await dbProvider.getAllItemsFromGenre(genre);

    // the products that are store on the server.
    try {
      Response response =
          await http.get(Uri.parse('${Utils.PATH}/movies/$genre'));

      log("Response from server: $response");

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> serverList = jsonDecode(response.body);
        List<Entity> serverListDecoded = [];

        for (int i = 0; i < serverList.length; i++) {
          Entity entity = Entity.fromJson(serverList[i]);
          bool found = false;

          for (int j = 0; j < initialItems.length; j++) {
            if (initialItems[j].id == entity.id) found = true;
          }
          if (!found) {
            dbProvider.insertEntity(entity);
          }
          serverListDecoded.add(entity);
        }

        return serverListDecoded;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Server Error ${e.toString()}");
      log("LOG: The server is offline (fetchItemsFromCategory)");
    }

    return initialItems;
  }

  Future<bool> add(Entity entity) async {
    await checkOnline();

    if (isOnline == false) {
      Fluttertoast.showToast(msg: "No internet connection");
      return false;
    }

    try {
      final data = entity.toJson();
      log('Add Entity: $entity');
      Response response = await http.post(Uri.parse('${Utils.PATH}/movie/'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});

      log("Status from server: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseMap = json.decode(response.body);
        entity.id = responseMap['id'];
        await dbProvider.insertEntity(entity);
        return true;
      } else {
        Fluttertoast.showToast(msg: "Error occured.");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Server Error");
      log("The server is offline (add)");
      return false;
    }
  }

  Future<bool> delete(Entity? entity) async {
    await checkOnline();

    if (isOnline == false) {
      Fluttertoast.showToast(msg: "Server is offline");
      return false;
    }

    if (entity != null) {
      try {
        Response response =
            await http.delete(Uri.parse('${Utils.PATH}/movie/${entity.id}'));
        dbProvider.deleteEntity(entity);

        log("Response from server: $response");
        return true;
      } catch (e) {
        Fluttertoast.showToast(msg: "Server Error");
        log("LOG: The server is offline. (delete)");
      }

      return false;
    }

    return false;
  }

  List<String> getTop3Genres(Map<String, int> genreMap) {
    String top1 = '', top2 = '', top3 = '';
    int max1 = 0, max2 = 0, max3 = 0;

    for (var v in genreMap.entries) {
      if (v.value > max1) {
        max3 = max2;
        max2 = max1;
        max1 = v.value;
        top3 = top2;
        top2 = top1;
        top1 = v.key;
      } else if (v.value > max2) {
        max3 = max2;
        max2 = v.value;
        top3 = top2;
        top2 = v.key;
      } else if (v.value > max3) {
        max3 = v.value;
        top3 = v.key;
      }
    }

    List<String> res = [top1, top2, top3];

    return res;
  }

  List<Pair> activeYears(Map<int, int> yearsMap) {
    List<Pair> yearsActive = [];
    for (var v in yearsMap.entries) {
      yearsActive.add(Pair(v.key, v.value));
    }

    for (int i = 0; i < yearsActive.length; i++) {
      for (int j = i + 1; j < yearsActive.length; j++) {
        Pair e1 = yearsActive[i];
        Pair e2 = yearsActive[j];

        if (e1.right < e2.right) {
          Pair aux = e1;
          yearsActive[i] = e2;
          yearsActive[j] = aux;
        }
      }
    }

    return yearsActive;
  }

  Future<List<Pair>> getActiveYears() async {
    try {
      Response response = await http.get(Uri.parse('${Utils.PATH}/all'));
      final Map<int, int> yearsMap = {};

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> serverList = jsonDecode(response.body);

        for (int i = 0; i < serverList.length; i++) {
          Entity entity = Entity.fromJson(serverList[i]);
          if (yearsMap.containsKey(entity.year)) {
            yearsMap.update(entity.year, (value) => value + 1);
          } else {
            yearsMap[entity.year] = 1;
          }
        }

        log("Response from server: $response");
        return activeYears(yearsMap);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Server is offline");
      log("LOG: The server is offline (fetch top 3 genres) $e");
    }

    return [];
  }

  Future<List<String>> getTopGenres() async {
    try {
      Response response = await http.get(Uri.parse('${Utils.PATH}/all'));
      final Map<String, int> genreMap = {};

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        List<dynamic> serverList = jsonDecode(response.body);
        List<Entity> serverListDecoded = [];

        for (int i = 0; i < serverList.length; i++) {
          Entity entity = Entity.fromJson(serverList[i]);
          if (genreMap.containsKey(entity.genre)) {
            genreMap.update(entity.genre, (value) => value + 1);
          } else {
            genreMap[entity.genre] = 1;
          }
        }

        // for (int i = 0; i < serverList.length; i++) {
        //   for (int j = i + 1; j < serverList.length; j++) {
        //     Entity e1 = serverListDecoded[i];
        //     Entity e2 = serverListDecoded[j];

        //     if (e1.difficulty.compareTo(e2.difficulty) > 0) {
        //       Entity aux = e1;
        //       serverListDecoded[i] = e2;
        //       serverListDecoded[j] = aux;
        //     } else if (e1.difficulty.compareTo(e2.difficulty) == 0) {
        //       if (e1.category.compareTo(e2.category) > 0) {
        //         Entity aux = e1;
        //         serverListDecoded[i] = e2;
        //         serverListDecoded[j] = aux;
        //       }
        //     }
        //   }
        // }
        log("Response from server: $response");
        return getTop3Genres(genreMap);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Server is offline");
      log("LOG: The server is offline (fetch top 3 genres) $e");
    }

    return [];
  }

  Future<Pair> getAllGenres() async {
    await checkOnline();

    if (categories.isEmpty) {
      categories = await fetchGenres();
      log("This is the list of categories: $categories");
    }
    Pair pair = Pair(categories, isOnline);
    return pair;
  }

  Future<Pair> getAllItemsFromGenre(String? genre) async {
    await checkOnline();
    List<Entity> items = await fetchItemsFromGenre(genre);
    return Pair(items, isOnline);
  }

  bool contains(List<Entity> l, Entity p) {
    for (int i = 0; i < l.length; i++) {
      if (l[i].id == p.id) {
        return true;
      }
    }

    return false;
  }
}
