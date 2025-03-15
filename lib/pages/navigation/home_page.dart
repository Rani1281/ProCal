// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/authentication/main_auth.dart';
import 'package:procal/models/delete_user_result.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/models/auth_page_design.dart';
import 'package:procal/models/my_toast.dart';
import 'package:procal/services/food_data_central.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Welcome To PROCAL ! ${FirebaseAuth.instance.currentUser!.displayName}"),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ); 
  }
}
