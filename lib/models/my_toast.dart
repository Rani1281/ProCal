import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyToast {

  static void show(String msg) {
    // Map<types,Color> colors = {
    //   types.message : Colors.lightBlue,
    //   types.error : Colors.red,
    //   types.warning : Colors.yellow[800]!,
    //   types.success : Colors.lightGreen,
    // };
    
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.lightBlue
    );
  }
  
}

// enum types {
//   error,
//   warning,
//   success,
//   message,
// }