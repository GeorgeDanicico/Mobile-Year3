import 'dart:async';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/active.dart';
import 'package:flutter_app/pages/list.dart';
import 'package:flutter_app/pages/topentity.dart';
import 'package:flutter_app/service/EntityService.dart';
import 'package:provider/provider.dart';

import '../model/Entity.dart';
import '../model/Pair.dart';
import 'action.dart';

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
      body: FutureBuilder<Pair?>(
          future: Provider.of<EntityService>(context).getAllGenres(),
          builder: ((context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<String> list = snapshot.data?.left;

              return ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  String? genre = list[index];
                  log('Device is online: ${snapshot.data?.right.toString()}');

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      index == 0
                          ? Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ActiveYearsWidget();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: const Text('Active years'),
                                ),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return TopEntityWidget();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: const Text('Top 3 genres'),
                                )
                              ],
                            )
                          : Column(),
                      index == 0
                          ? Row(
                              children: [
                                snapshot.data?.right == false
                                    ? Text("Server is offline")
                                    : Text("Server is online"),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(),
                                  child: const Text('Refresh'),
                                )
                              ],
                            )
                          : Column(),
                      ListTile(
                        title: Text('Genre: $genre'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: const Text('SHOW MOVIES'),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ListEntityWidget(
                                    genre != null ? genre : '');
                              }));
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
          })),
    );
  }
}
