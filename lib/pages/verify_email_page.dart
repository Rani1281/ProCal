

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/home_page.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {

  User? user = FirebaseAuth.instance.currentUser;
  final FirestoreService _firestore = FirestoreService();

  final AuthService _auth = AuthService();

  Timer? timer;
  bool isEmailVerified = false;

  @override
  void initState() {
    if (user != null) {
      isEmailVerified = user!.emailVerified;
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
    // probably don't need this check but it works
    return isEmailVerified ? const HomePage() :  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Verify Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text("A verification email has been sent to the email ${user?.email}"),
            const SizedBox(height: 15),
            // Delete account button
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  _firestore.deleteUser(user!.uid);
                  _auth.deleteUserAccount();
                }
              },
              child: const Text('Delete Account'),
            ),
            const SizedBox(height: 15),

            // Resend verification email button
            ElevatedButton(
              onPressed: () {
                if (user != null) {
                  user?.sendEmailVerification();
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