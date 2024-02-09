import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/constants.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool isTaskCompleted;
  void Function(bool?)? onChangeTaskStatus;
  void Function(BuildContext)? deleteFunction;
  void Function(BuildContext)? copyToClipboardFunction;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.isTaskCompleted,
    required this.onChangeTaskStatus,
    required this.deleteFunction,
    required this.copyToClipboardFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 12, left: 12),
      child: Slidable(
        key: const ValueKey(0),
        // closeOnScroll: true,
        endActionPane: ActionPane(
          extentRatio: 0.35, // 0.6
          // dismissible: DismissiblePane(onDismissed: () {}),
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: copyToClipboardFunction,
              icon: Icons.copy_outlined,
              backgroundColor: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              // autoClose: true,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadiusDirectional.circular(8),
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(12),
          // margin: const EdgeInsets.only(top: 25, right: 12, left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // text : task name
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    taskName,
                    style: TextStyle(
                        fontSize: 18,
                        decoration: isTaskCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
              ),

              // check box : task completed or not
              Checkbox(
                value: isTaskCompleted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                onChanged: onChangeTaskStatus,
                activeColor: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
