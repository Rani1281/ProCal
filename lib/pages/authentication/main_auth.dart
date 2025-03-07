import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/models/auth_page_design.dart';
import 'package:procal/components/my_button.dart';
import 'package:procal/components/my_text_field.dart';
import 'package:procal/models/my_toast.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:sign_in_button/sign_in_button.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({required this.destination, super.key});

  final AuthPages destination;

  @override
  MainAuthPageState createState() => MainAuthPageState();
}

class MainAuthPageState extends State<MainAuthPage> {
  late AuthPages destination;
  late Map<AuthPages, AuthPageModel> authPages;

  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();

  final TextEditingController emailControler = TextEditingController();
  final TextEditingController passwordControler = TextEditingController();
  final TextEditingController usernameControler = TextEditingController();

  late String email;
  late String password;
  late String username;

  bool isSecured = true;

  void signUp() async {
    // create account
    User? user = await _auth.createAccountWithEmailAndPassword(email, password);

    if(user != null) {
      // update username
      _auth.updateUsername(username);

      // add to firestore
      String? userId = _auth.getUserID();
      _firestore.addUser(email, username, userId!);
    }
  }

  void logIn() async {
    await _auth.signInWithEmailAndPassword(email, password);
  }

  void reauth() async {
    await _auth.reauthenticate(email, password);
  }

  @override
  void initState() {
    super.initState();
    destination = widget.destination;

    authPages = {
      AuthPages.signUp: AuthPageModel(
        title: 'Sign Up',
        onPressed: signUp,
        buttonText: 'Create Account',
        bottomText: 'Already have an account? Log In',
        bottomTextDestination: AuthPages.logIn,
      ),
      AuthPages.logIn: AuthPageModel(
        title: 'Log In',
        onPressed: logIn,
        buttonText: 'Log In',
        bottomText: "Don't have an account? Sign Up",
        bottomTextDestination: AuthPages.signUp,
      ),
      AuthPages.reAuth: AuthPageModel(
        title: 'Re-Log',
        onPressed: reauth,
        buttonText: 'Re-Log'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final thisPage = authPages[destination]!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(thisPage.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              destination == AuthPages.signUp
                ? Column(
                    children: [
                      // Username field
                      MyTextField(
                        controller: usernameControler,
                        hintText: 'Username'),
                      const SizedBox(height: 15)
                    ],
                  )
                : const SizedBox(),

              // Email field
              MyTextField(
                controller: emailControler,
                hintText: 'Email',
              ),
              const SizedBox(height: 15),

              // Password field
              MyTextField(
                controller: passwordControler,
                hintText: 'Password',
                hidePassword: isSecured,
                endIcon: IconButton(
                    icon: isSecured
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        isSecured = !isSecured;
                      });
                    }),
              ),
              const SizedBox(height: 15),

              // Submit button
              MyButton(
                text: thisPage.buttonText,
                onPressed: () {
                  updateInput();
                  if (formIsFilled()) {
                    thisPage.onPressed();
                  } else {
                    MyToast.show('Please fill all the fields before continuing');
                  }
                },
              ),
              const SizedBox(height: 20),

              // Bottom text
              thisPage.bottomTextDestination != null
                ? InkWell(
                  onTap: () {
                    setState(() {
                      destination = thisPage.bottomTextDestination!;
                    });
                  },
                  child: Text(thisPage.bottomText!))
                : const SizedBox(),

              const SizedBox(height: 15),

              // OR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container(height: 1, color: Colors.grey)),
                  const SizedBox(width: 3),
                  const Text('OR'),
                  const SizedBox(width: 3),
                  Expanded(
                      child: Container(height: 1, color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 20),
              
              // For some reason gives an error (cause it can't find the image)
              //SignInButton(Buttons.google, onPressed: _auth.signInWithGoogle),
              MyButton(
                text: "Continue with Google",
                onPressed: _auth.signInWithGoogle,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // Checks if the input is empty or not. If it is - returns false, Else - returns true
  bool formIsFilled() {
    if (email.isNotEmpty  && password.isNotEmpty) {
      if (destination == AuthPages.signUp) {
        if (username != '') {
          return true;
        }
        return false;
      }
      return true;
    }
    return false;
  }

  void updateInput() {
    setState(() {
      email = emailControler.text.trim();
      password = passwordControler.text.trim();
      username = usernameControler.text.trim();
    });
  }
}
