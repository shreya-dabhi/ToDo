import 'package:flutter/material.dart';
import 'package:todo/constants.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController textController;
  final void Function()? onSave;
  final void Function()? onCancel;
  // Initialise a scroll controller.
  ScrollController scrollController = ScrollController();

  DialogBox(
      {super.key,
      required this.textController,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: tertiaryColor,
      iconPadding: const EdgeInsets.only(top: 10, right: 10),
      icon: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
      ),
      title: Text('Add New Task'),
      content: Container(
        // padding: const EdgeInsets.all(20),
        // height: 180,
        height: MediaQuery.of(context).size.height / 4.5,
        decoration: BoxDecoration(
          // color: tertiaryColor,
          borderRadius: BorderRadiusDirectional.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // take user input
            Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: TextField(
                scrollController: scrollController,
                controller: textController,
                minLines: 1,
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                showCursor: true,
                autocorrect: true,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(14),
                    hintText: 'Write / Think 🤔',
                    suffixStyle: TextStyle(backgroundColor: Colors.grey),
                    suffixIcon: IconButton(
                      onPressed: () {
                        textController.clear();
                      },
                      icon: Icon(Icons.clear),
                    )),
              ),
            ),

            // action buttons : save & cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      onPressed: onSave,
                      color: tertiaryColor,
                      icon: Icon(Icons.send_rounded),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
