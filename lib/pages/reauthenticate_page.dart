import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/login_page.dart';
import 'package:procal/pages/signup_page.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';

class ReAuthPage extends StatefulWidget {
  const ReAuthPage({super.key});

  @override
  State<ReAuthPage> createState() => _ReAuthPageState();
}

class _ReAuthPageState extends State<ReAuthPage> {

  bool isSecured = true;

  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();

  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();


  Future<void> reLogUser() async {

    String? email = emailControler.text.trim();
    String? password = passwordControler.text.trim();

    bool userReAuthenticated = await _auth.reauthenticate(email, password);

    if(user != null) {

      if(userReAuthenticated) {
        user!.reload();
        // Deletes user again
        _firestore.deleteUser(user!.uid);
        bool userDeleted = await _auth.deleteUserAccount();
        
        if(userDeleted) {
          // Go back to home page
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
    }
    }
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Re-login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text("In order to delete your account, you first must re-fill your information"),
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
              onPressed: () => reLogUser(),       
              child: const Text('Login')
            ),
            // Create an account
            const SizedBox(height: 0),

            // Dont have an account
            InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignupPage()
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
