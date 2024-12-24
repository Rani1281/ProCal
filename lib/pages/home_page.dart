import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Welcome To PROCAL !"),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: signOut,
                child: const Text('Sign Out')
              ),
            ],
          ),
        ),
      ),
    );
    
  }
  Future<void> signOut() async => await FirebaseAuth.instance.signOut();

  
}