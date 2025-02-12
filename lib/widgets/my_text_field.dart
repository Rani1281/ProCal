import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.hidePassword,
      this.endIcon,
      this.sumbitType,
      this.onSubmitted});

  final TextEditingController controller;
  final String hintText;
  final bool? hidePassword;
  final Widget? endIcon;
  final TextInputAction? sumbitType;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide.none,
        ),
        suffixIcon: endIcon ?? const SizedBox(),
      ),
      obscureText: hidePassword ?? false,
      textInputAction: sumbitType ?? TextInputAction.done,

      onSubmitted: onSubmitted,
    );
  }
}
