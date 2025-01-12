import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/services/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome To PROCAL ! ${FirebaseAuth.instance.currentUser!.email}"),
              const SizedBox(height: 15),

              // Log out button
              ElevatedButton(
                onPressed: _auth.signOut,
                child: const Text('Log Out')
              ),
              const SizedBox(height: 15),

              // Delete account button
              ElevatedButton(
                onPressed: () {},
                child: const Text('Delete Account')
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}