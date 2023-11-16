// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:note_todo/components/dialogue_box.dart';
import 'package:note_todo/components/todo_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_todo/data/data_base.dart';
import 'package:logger/logger.dart';

void main() async {
  await Hive.initFlutter();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Box _todoList;
  ToDoDataBase db = ToDoDataBase();
  final controller = TextEditingController();
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Create an async method to initialize the Hive box
  Future<void> initialize() async {
    try {
      _todoList = await Hive.openBox('todoList');

      // default data
      if (_todoList.get("TODOLIST") == null) {
        await db.createInitialData();
      } else {
        await db.loadData();
      }

      // Ensure the UI is updated after data is loaded
      setState(() {});
    } catch (e, stackTrace) {
      _logger.e('Error initializing Hive', e, stackTrace);
    }
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateData();
  }

  Future<void> saveNewTask() async {
    setState(() {
      db.toDoList.add([controller.text, false]);
      controller.clear();
    });
    Navigator.pop(context);
    await db.updateData();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    if (_todoList == null) {
      // Loading indicator or placeholder can be shown while data is loading
      return CircularProgressIndicator();
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'TO DO',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            height: 2.5,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
