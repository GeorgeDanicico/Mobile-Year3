import 'package:flutter/material.dart';
import 'package:flutter_app/pages/action.dart';
import 'package:flutter_app/pages/home.dart';
import 'package:flutter_app/repo/DBRepo.dart';
import 'package:flutter_app/service/EntityService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.

  runApp(ChangeNotifierProvider(
      create: (_) => EntityService(ServerRepository()),
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
          SizedBox(height: 700.0, width: double.infinity, child: HomeWidget()),
    );
  }
}
