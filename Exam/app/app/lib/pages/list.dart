import 'package:flutter/material.dart';
import 'package:flutter_app/service/EntityService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../model/Entity.dart';
import '../model/Pair.dart';
import 'action.dart';

class ListEntityWidget extends StatefulWidget {
  final String category;

  const ListEntityWidget(this.category);
  @override
  State<ListEntityWidget> createState() => _ListEntityWidgetState();
}

class _ListEntityWidgetState extends State<ListEntityWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: FutureBuilder<Pair?>(
          future: Provider.of<EntityService>(context)
              .getAllItemsFromGenre(widget.category),
          builder: ((context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<Entity> list = snapshot.data?.left;

              return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    Entity? entity = list[index];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                              'Name: ${entity?.name}   Genre: ${entity?.genre}   Year: ${entity?.year}'),
                          subtitle: Text(
                              'Description: ${entity?.description}   Director: ${entity?.director}'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const SizedBox(width: 8),
                            TextButton(
                              child: const Text('DELETE'),
                              onPressed: () {
                                _dialogBuilder(context, entity);
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
                  });
            } else {
              return const CircularProgressIndicator();
            }
          })),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddWidget();
            }));
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _dialogBuilder(BuildContext context, Entity? entity) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('You are about to delete an object.\n'
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
              onPressed: () async {
                bool response =
                    await Provider.of<EntityService>(context, listen: false)
                        .deleteEntity(entity);

                if (response == true) {
                  Fluttertoast.showToast(msg: "The movie has been deleted");
                  Navigator.of(context).pop();
                } else {
                  Fluttertoast.showToast(msg: "An error has occured");
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
