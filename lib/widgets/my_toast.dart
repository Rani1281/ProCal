import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyMoast {

  void show(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.lightBlue
    );
  }
  
}