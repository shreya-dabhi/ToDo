import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/constants.dart';
import 'package:todo/data/database.dart';

import '../components/dialog_box.dart';
import '../components/todo_tile.dart';

//TODO: make the notes app

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //region define variables

  // reference the database and box
  ToDoDataBase db = ToDoDataBase();
  final _myBox = Hive.box('myBox');

  final textController = TextEditingController();
  //endregion

  //region define methods

  // toggle checkbox true/false
  void changeTaskStatus(bool? updatedStatus, int index) {
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];
    });
    db.updateDatabase();
  }

  // create new task
  void createNewTask() {
    // show dialog box
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        textController: textController,
        onSave: saveNewTask,
        onCancel: () {
          // close the dialog
          Navigator.of(context).pop();

          //clear the controller
          textController.clear();
        },
      ),
    ).then((value) => textController.clear());
  }

  // save button : save new task
  void saveNewTask() {
    if (textController.text.trim().isNotEmpty) {
      // close the dialog
      Navigator.of(context).pop();

      // add new task to list
      setState(() {
        db.todoList.add([textController.text, false]);
      });

      db.updateDatabase();

      //clear the controller
      textController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        content: Center(
          child: Text(
            'Please enter the value in field.',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ));
    }
  }

  // show alert before deleting note
  void showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(
          top: 25,
          left: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: const Text(
          'Are you sure want to delete ?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'No',
              style: TextStyle(
                fontSize: 16,
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                // close the dialog
                Navigator.pop(context);

                // delete the task
                deleteTask(index);
              }),
        ],
      ),
    );
  }

  // delete a task
  void deleteTask(int index) {
    // delete from list and rebuild widget
    setState(() {
      db.todoList.removeAt(index);
    });
    // notify to user
    ShowSnackBar(textToDisplay: 'Deleted successfully.');

    db.updateDatabase();
  }

  // copy task
  void copyTaskToClipboard(int index) async {
    await Clipboard.setData(ClipboardData(text: db.todoList[index][0])).then(
      (value) => ShowSnackBar(textToDisplay: 'Copied to clipboard!'),
    ); // copied successfully & notifying user
  }

  // display a message to user in bottom snackbar
  void ShowSnackBar({required String textToDisplay}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            textToDisplay,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Colors.black87,
        //region code for center user notification at bottom
        // width: MediaQuery.of(context).size.width / 2,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadiusDirectional.circular(30)),
        //endregion
      ),
    );
  }
  //endregion

  //region define UI
  @override
  void initState() {
    if (_myBox.get("TODOLIST") != null) {
      db.loadData();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tertiaryColor,
      appBar: AppBar(
        title: const Text(
          'TO DO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 3,
        // foregroundColor: Colors.black,
        backgroundColor: primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.add,
          // color: Colors.black,
        ),
      ),
      body: db.todoList.isEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // icon
                    Icon(
                      Icons.done_outline_rounded,
                      color: primaryColor,
                      size: 80,
                    ),

                    const SizedBox(
                      height: 50,
                    ),

                    // message
                    Text(
                      'You\'re ahead of the game! No task to tackle right now.',
                      // 'All done! Time to reward yourself for your hard work.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            )
          : Scrollbar(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: db.todoList.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    taskName: db.todoList[index][0],
                    isTaskCompleted: db.todoList[index][1],
                    onChangeTaskStatus: (status) =>
                        changeTaskStatus(status, index),
                    deleteFunction: (context) =>
                        showDeleteDialog(context, index),
                    copyToClipboardFunction: (context) =>
                        copyTaskToClipboard(index),
                  );
                },
              ),
            ),
    );
  }
  //endregion
}
