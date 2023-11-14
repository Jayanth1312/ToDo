import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  List toDoList = []; //list of todos
  //refrence to the hive box
  final todoList = Hive.box('todoList');

  //constructor for the first time opening this app
  void createInitialData() {
    toDoList = [
      ["Write a story", false],
      ["Read a book", false]
    ];
  }
  //load the data from the hive box
  void loadData() {
    toDoList = todoList.get('TODOLIST');
  }
  //updating the database
  void updateData() {
    todoList.put('TODOLIST', toDoList);
  }
}
