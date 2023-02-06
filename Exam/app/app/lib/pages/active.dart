import 'package:flutter/material.dart';
import 'package:flutter_app/service/EntityService.dart';
import 'package:provider/provider.dart';

import '../model/Entity.dart';
import '../model/Pair.dart';
import 'action.dart';

class ActiveYearsWidget extends StatefulWidget {
  @override
  State<ActiveYearsWidget> createState() => _ActiveYearsWidgetState();
}

class _ActiveYearsWidgetState extends State<ActiveYearsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Years'),
      ),
      body: FutureBuilder<List<Pair>?>(
          future: Provider.of<EntityService>(context).getActiveYears(),
          builder: ((context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Pair? p = snapshot.data?[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Text('${index + 1}'),
                          title:
                              Text('Year: ${p?.left}      Movies: ${p?.right}'),
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
