import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/home_page.dart';
import 'package:procal/pages/signup_page.dart';
import 'package:procal/services/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  final TextEditingController emailControler = TextEditingController();

  final TextEditingController passwordControler = TextEditingController();

  bool isSecured = true;

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
              decoration: InputDecoration(
                label: const Text('Password'),
                suffixIcon: IconButton(
                      icon: isSecured
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isSecured = !isSecured;
                        });
                      }),
              ),
              obscureText: isSecured,
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
