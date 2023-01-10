import 'package:flutter/material.dart';
import 'package:flutter_app/pages/add.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/repo/DBRepo.dart';
import 'package:flutter_app/service/ProductService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.

  runApp(ChangeNotifierProvider(
      create: (_) => ProductService(ServerRepository()),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp())));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          SizedBox(height: 580.0, width: double.infinity, child: HomeWidget()),
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
}
