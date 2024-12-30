import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/home_page.dart';
import 'package:procal/pages/signup_page.dart';
import 'package:procal/services/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthService _auth = AuthService();
  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();

  void signIn(BuildContext context) async {
    User? user = await _auth.signInWithEmailAndPassword(
      emailControler.text.trim(),
      passwordControler.text.trim()
    );
    if(user != null) {
      print('USER CREATED');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
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
        title: const Text("Login"),
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
            // Login button
            ElevatedButton(
                onPressed: () => signIn(context),       
                child: const Text('Login')
            ),
            // Create an account
            const SizedBox(height: 0),
            // Dont have an account
            InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>  SignupPage()
                  )
                );
                },
                child: const Text('Don\'t have an account? Sign Up'))
          ],
        ),
      ),
    );
  }
}
