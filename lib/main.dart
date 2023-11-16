import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_todo/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();
  //open a box
  var box = await Hive.openBox('todoList');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
