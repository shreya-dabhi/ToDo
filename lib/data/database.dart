import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  //region variables
  // reference the box
  final _myBox = Hive.box('myBox');

  List todoList = [];
  //endregion

  //region methods
  // load the existing data
  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }

  // update the data
  void updateDatabase() {
    _myBox.put("TODOLIST", todoList);
  }
  //endregion
}
