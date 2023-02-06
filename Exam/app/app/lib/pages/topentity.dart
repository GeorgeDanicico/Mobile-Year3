import 'package:flutter/material.dart';
import 'package:flutter_app/service/EntityService.dart';
import 'package:provider/provider.dart';

import '../model/Entity.dart';
import 'action.dart';

class TopEntityWidget extends StatefulWidget {
  @override
  State<TopEntityWidget> createState() => _TopEntityWidgetState();
}

class _TopEntityWidgetState extends State<TopEntityWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top 3 genres'),
      ),
      body: FutureBuilder<List<String>?>(
          future: Provider.of<EntityService>(context).getTop3Genres(),
          builder: ((context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String? genre = snapshot.data?[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Text('${index + 1}'),
                          title: Text('Genre: ${genre}'),
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
    );
  }
}
