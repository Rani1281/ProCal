import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        foregroundColor: textColor ?? Colors.black,
        fixedSize: Size(MediaQuery.of(context).size.width, 30),
        
      ),
      // style: ButtonStyle(
      //   backgroundColor: WidgetStateProperty.all<Color>(bgColor ?? Colors.lightBlue),
      //   foregroundColor: WidgetStateProperty.all<Color>(textColor ?? Colors.black),
      //   fixedSize: WidgetStateProperty.all<Size?>(Size.fromWidth(MediaQuery.of(context).size.width)),
      //   padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12)),
      //   iconSize: WidgetStateProperty.all(20),
      // ),

    );
  }
}