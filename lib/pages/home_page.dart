import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/auth_page.dart';
import 'package:procal/pages/login_page.dart';
import 'package:procal/pages/reauthenticate_page.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';

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
    
    if(user != null){
      _firestore.deleteUser(user!.uid);
      bool userDeleted = await _auth.deleteUserAccount();
      if(!userDeleted) {
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => const LoginPage()),
        //   (Route<dynamic> route) => false,
        // );
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const ReAuthPage())
        );
      }
    }
    // else {
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => const LoginPage()),
    //     (Route<dynamic> route) => false,
    //   );
    // }
  }

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
                onPressed: () => deleteUser(),
                child: const Text('Delete Account')
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}