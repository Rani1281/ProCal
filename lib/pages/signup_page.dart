import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:procal/services/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final AuthService _auth = AuthService();

  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  //TextEditingController usernameControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Email field
            TextField(
              controller: emailControler,
              decoration: const InputDecoration(
                label: Text('Email'),
              ),
            ),
            const SizedBox(height: 15),
            // Password field
            TextField(
              controller: passwordControler,
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
            ),
            const SizedBox(height: 15),
            // Create account button
            ElevatedButton(
              onPressed: createUserAccount,
              child: const Text('Create Account')
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createUserAccount() async {
    String errorMessage = '';
    String email = emailControler.text.trim();
    String password = passwordControler.text.trim();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak';
      }
      else if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use';
      }
      else {
        errorMessage = 'Something went wrong';
      }
      showToast(
        errorMessage,
        context: context,
        position: const StyledToastPosition(align: Alignment.center),
        animation: StyledToastAnimation.fade,
      );  
    } catch (e) {
      print(e);
    }
  }
}
