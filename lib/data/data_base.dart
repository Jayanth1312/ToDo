import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = []; //list of todos
  //reference to the hive box
  final todoList = Hive.box('todoList');

  //constructor for the first time opening this app
  Future<void> createInitialData() async {
    toDoList = [
      ["Write a story", false],
      ["Read a book", false]
    ];
  }

  //load the data from the hive box
  Future<void> loadData() async {
    toDoList = todoList.get('TODOLIST');
  }

  //updating the database
  Future<void> updateData() async {
    todoList.put('TODOLIST', toDoList);
  }
}
