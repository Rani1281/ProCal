

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procal/pages/home_page.dart';
import 'package:procal/services/firebase_firestore.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

  User? user = FirebaseAuth.instance.currentUser;
  final FirestoreService _firestore = FirestoreService();
  Timer? timer;
  bool isEmailVerified = false;

  @override
  void initState() {
    isEmailVerified = user!.emailVerified;
    if (user != null) {
      user!.sendEmailVerification();
      print('FIRST EMAIL VERIFICATION SENT');
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await checkEmailVerified();
      });
    }
    super.initState();
  }

  Future<void> checkEmailVerified() async {
    print('Checking email verification...');
    await user!.reload();
    user = FirebaseAuth.instance.currentUser;
    if (user!.emailVerified) {
      print('EMAIL VERIFIED');
      setState(() {
        isEmailVerified = true;
      });
      timer?.cancel();
    }
    else {
      print('EMAIL NOT VERIFIED');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    print('TIMER STOPPED');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified ? const HomePage() :  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Verify Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text("A verification email has been sent to your email address"),
            const SizedBox(height: 15),
            // Delete account button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (user != null) {
                  user!.delete();
                  _firestore.deleteUser(user!.uid);
                  Fluttertoast.showToast(msg: 'Account Deleted');
                }
              },
              child: const Text('Delete Account'),
            ),
            const SizedBox(height: 15),
            // Resend verification email button
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  user!.sendEmailVerification();
                }
              },
              child: const Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}