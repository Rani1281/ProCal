// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/auth_pages/main_auth.dart';
import 'package:procal/models/delete_user_result.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/models/auth_page_design.dart';
import 'package:procal/models/my_toast.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> deleteUser() async {
    if (user != null) {
      DeleteUserResult? result = await _auth.deleteUserAccount();
      if (result != null) {
        MyToast.show(result.errorMessage!);
        if (result.isSuccessful == false) {
          // Navigate to re-login page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const MainAuthPage(destination: AuthPages.reAuth)));
        }
      }
    }
  }

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

  bool isAnon() {
    if (user!.isAnonymous) {
      return true;
    }
    return false;
  }
}
