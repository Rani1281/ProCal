import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.text, required this.onPressed, this.bgColor, this.textColor, this.icon});

  final String text;
  final void Function() onPressed;
  final Widget? icon;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(text),
      icon: icon,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? Colors.lightBlue,
        foregroundColor: textColor ?? Colors.white,
        fixedSize: Size(MediaQuery.of(context).size.width, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
        ),
      ),
    );
  }
}