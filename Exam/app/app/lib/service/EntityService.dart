import 'dart:async';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/Entity.dart';
import 'package:flutter_app/repo/DBRepo.dart';

import '../model/Pair.dart';

class EntityService extends ChangeNotifier {
  final ServerRepository _repository;
  late StreamSubscription networkSubscription;

  EntityService(this._repository);

  Future<bool> addEntity(Entity entity) async {
    bool isValid = await _repository.add(entity);

    return isValid;
  }

  Future<Pair> getAllGenres() {
    return _repository.getAllGenres();
  }

  Future<List<Pair>> getActiveYears() {
    return _repository.getActiveYears();
  }

  Future<List<String>> getTop3Genres() {
    return _repository.getTopGenres();
  }

  Future<Pair> getAllItemsFromGenre(String? category) async {
    return _repository.getAllItemsFromGenre(category);
  }

  Future<bool> deleteEntity(Entity? entity) async {
    bool returnValue = await _repository.delete(entity);

    notifyListeners();

    return returnValue;
  }
}
