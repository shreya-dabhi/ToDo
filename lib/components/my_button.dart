import 'package:flutter/material.dart';

import '../constants.dart';

class MyButton extends StatelessWidget {
  final String btnName;
  final void Function()? onPressed;

  const MyButton({super.key, required this.btnName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
      ),
      child: Text(
        btnName,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
