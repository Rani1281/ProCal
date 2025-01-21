import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/widgets/auth_pages.dart';
import 'package:procal/widgets/my_toast.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({required this.destination, super.key});

  final String destination;

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {

  late String destination;
  late List<AuthPageDesign> authPages;
  late Map<String, int> pageIndexes = {
    'sign-up': 0,
    'log-in': 1,
    're-auth': 2, 
  };

  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  final MyMoast myMoast = MyMoast();

  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();
  final TextEditingController usernameControler = TextEditingController();
  
  late String email;
  late String password;
  late String username;

  bool isSecured = true;

  @override
  void initState() {
    super.initState();
    destination = widget.destination;

    authPages = [
    AuthPageDesign(title: 'Sign Up', onPressed: signUp, buttonText: 'Create Account', bottomText: 'Already have an account? Log In', bottonTextDestination: 'log-in'),
    AuthPageDesign(title: 'Log In', onPressed: signIn, buttonText: 'Log In', bottomText: "Don't have an account? Sign Up", bottonTextDestination: 'sign-up'),
    AuthPageDesign(title: 'Re-Log', onPressed: reAuthUser, buttonText: 'Re-Log'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    int id = pageIndexes[destination]!;
    AuthPageDesign thisPage = authPages[id];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(thisPage.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [

            destination == 'sign-up'
            ? Column(
              children: [
                // Username field
                TextField(
                  controller: usernameControler,
                  decoration: const InputDecoration(
                    label: Text('Username'),
                  ),
                ),
                const SizedBox(height: 15)
              ],
            )
            : const SizedBox(),

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
              obscureText: isSecured,
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
                )),
            const SizedBox(height: 15),

            // Submit button
            ElevatedButton(
              onPressed: () {
                if(checkIfFilled()) {
                  thisPage.onPressed();
                }
                else {
                  myMoast.show('Please fill all the fields before continuing');
                }
                
              },
              
              child: Text(thisPage.buttonText)
            ),
            // Have an account
            const SizedBox(height: 15),
            thisPage.bottonTextDestination != null
            ? InkWell(
                onTap: () {
                  setState(() {
                    destination = thisPage.bottonTextDestination!;
                  });
                },
                child: Text(thisPage.bottomText!)
              )
            : const SizedBox(),
          ],
        ),
      ),
    );
  }
  
  // sign up
  Future<void> signUp() async {
    User? user = await _auth.createAccountWithEmailAndPassword(
      email,
      password,
    );
    if (user != null) {
      await _firestore.addUser(
        email,
        username,
        user.uid,
      );
      // if (!user.emailVerified) {
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => const VerifyEmailPage()));
      // } else if (user.emailVerified) {
      //   Navigator.pushReplacement(
      //       context, MaterialPageRoute(builder: (context) => const HomePage()));
      // }
    } else {
      print('USER NOT CREATED');
    }
  }

  // sign in
  Future<void> signIn() async {
    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if(user != null) {
      print('USER CREATED');
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
    else {
      print('USER NOT CREATED');
    }
  }

  // re-auth user
  Future<void> reAuthUser() async {
    final User? user = FirebaseAuth.instance.currentUser;

    // is true or false based on if the user was re-authenticated or not
    bool userReAuthenticated = await _auth.reauthenticate(email, password);

    if(user != null) {
      if(userReAuthenticated) {
        user.reload();
        // Deletes user again
        _firestore.deleteUser(user.uid);
        bool userDeleted = await _auth.deleteUserAccount();

        // Suggestion: maybe add a while loop for userReAuthenticated
        
        if(!userDeleted) {
          // Restore user info in firestore
          int addSign = email.indexOf('@');
          String restoredUsername = email.substring(0, addSign);
          _firestore.addUser(email, restoredUsername, user.uid);
          Fluttertoast.showToast(msg: "An error accured while deleting account", gravity: ToastGravity.CENTER);
        }
      }
    }  
  }

  // Checks if the input is null or not. If it is - returns false, Else - returns true
  bool checkIfFilled() {
    setState(() {
      email = emailControler.text.trim();
      password = passwordControler.text.trim();
      username = usernameControler.text.trim();
    });
    if(email != '' && password != '') {
      // Email & password are not null
      if(destination == 'sign-up') {
        // It is sign up page
        if(username != '') {
          // Then also check username
          return true;
        }
        return false;
      }
      // It is'nt sign up page
      return true;
    }
    return false;
  }
}