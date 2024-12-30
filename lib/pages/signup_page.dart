import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/home_page.dart';
import 'package:procal/pages/login_page.dart';
import 'package:procal/pages/verify_email_page.dart';
import 'package:procal/services/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final AuthService _auth = AuthService();
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();
  //TextEditingController usernameControler = TextEditingController();

  void signUp() async {
    User? user = await _auth.createAccountWithEmailAndPassword(
      emailControler.text.trim(),
      passwordControler.text.trim()
    );
    if(user != null) {
      print('USER CREATED!');

      if(!user.emailVerified) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyEmailPage()));
      }
      else if(user.emailVerified) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }
    else {
      print('USER NOT CREATED');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Email field
            TextField(
              controller: emailControler,
              keyboardType: TextInputType.emailAddress,
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
              onPressed: () => signUp(),
              child: const Text('Create Account')
            ),
            // Have an account
            const SizedBox(height: 15),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginPage()
                  )
                );
              },
              child: const Text('Already have an account? Login')
            )
          ],
        ),
      ),
    );
  }
}
