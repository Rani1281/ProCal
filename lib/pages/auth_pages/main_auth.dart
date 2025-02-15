import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/models/auth_page_design.dart';
import 'package:procal/models/my_button.dart';
import 'package:procal/models/my_text_field.dart';
import 'package:procal/models/my_toast.dart';
import 'package:sign_in_button/sign_in_button.dart';

class MainAuthPage extends StatefulWidget {
  const MainAuthPage({required this.destination, super.key});

  final AuthPages destination;

  @override
  MainAuthPageState createState() => MainAuthPageState();
}

class MainAuthPageState extends State<MainAuthPage> {
  late AuthPages destination;
  late Map<AuthPages, AuthPageDesign> authPages;

  final AuthService _auth = AuthService();
  final MyToast myToast = MyToast();

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

    authPages = {
      AuthPages.signUp: AuthPageDesign(
        title: 'Sign Up',
        onPressed: () async => await _auth.createAccountWithEmailAndPassword(
            email, password, username),
        buttonText: 'Create Account',
        bottomText: 'Already have an account? Log In',
        bottomTextDestination: AuthPages.logIn,
      ),
      AuthPages.logIn: AuthPageDesign(
        title: 'Log In',
        onPressed: () async =>
            await _auth.signInWithEmailAndPassword(email, password),
        buttonText: 'Log In',
        bottomText: "Don't have an account? Sign Up",
        bottomTextDestination: AuthPages.signUp,
      ),
      AuthPages.reAuth: AuthPageDesign(
          title: 'Re-Log',
          onPressed: () async => await _auth.reauthenticate(email, password),
          buttonText: 'Re-Log'),
      AuthPages.upgrade: AuthPageDesign(
        title: 'Upgrade Account',
        onPressed: () =>
            _auth.upgradeAccountFromAnonToPermenant(email, password, username),
        buttonText: 'Upgrade Account',
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final AuthPageDesign thisPage = authPages[destination]!;

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
                        // TextField(
                        //   controller: usernameControler,
                        //   decoration: const InputDecoration(
                        //     label: Text('Username'),
                        //   ),
                        // ),
                        const SizedBox(height: 15)
                      ],
                    )
                  : const SizedBox(),

              // Email field
              MyTextField(controller: emailControler, hintText: 'Email'),

              // TextField(
              //   controller: emailControler,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: const InputDecoration(
              //     label: Text('Email'),
              //   ),
              // ),
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
              // TextField(
              //   obscureText: isSecured,
              //     controller: passwordControler,
              //     decoration: InputDecoration(
              //       label: const Text('Password'),
              //       suffixIcon: IconButton(
              //           icon: isSecured
              //             ? const Icon(Icons.visibility_off)
              //             : const Icon(Icons.visibility),
              //           onPressed: () {
              //             setState(() {
              //               isSecured = !isSecured;
              //             });
              //           }),
              //     )),
              const SizedBox(height: 15),

              // Submit button
              MyButton(
                text: thisPage.buttonText,
                onPressed: () {
                  if (formIsFilled()) {
                    // Activate this page's function
                    thisPage.onPressed();
                  } else {
                    myToast
                        .show('Please fill all the fields before continuing');
                  }
                },
              ),

              // Have an account
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

              SignInButton(Buttons.google, onPressed: _auth.signInWithGoogle),

              // Continue with google button
              // Row(
              //   children: [
              //     SizedBox(
              //       height: 30,
              //       width: 30,
              //       child: Image.asset('assets/google-logo.png')
              //     ),

              //     const SizedBox(width: 14),

              //     Expanded(
              //       child: SizedBox(
              //         height: 50,
              //         child: ElevatedButton.icon(
              //           onPressed: _auth.signInWithGoogle,
              //           label: const Text('Continue With Google'),
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Colors.white,
              //             foregroundColor: Colors.black87,
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // ElevatedButton(
              //   onPressed: () => _auth.signInWithGoogle(),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.lightBlue,
              //   ),

              //   child: const Row(
              //     children: [
              //       // google logo
              //       //Image.asset(name)
              //       Text('Continue with google'),
              //     ],
              //   ),

              // ),

              const SizedBox(height: 8),

              // Anonimously button

              // isNotAnon()
              // ? MyButton(
              //   text: 'Sign In Anonimously',
              //   onPressed: () => _auth.signInAnon(),
              //   bgColor: Colors.white,
              //   icon: const Icon(Icons.person),
              // )
              // : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Checks if the input is null or not. If it is - returns false, Else - returns true
  bool formIsFilled() {
    setState(() {
      email = emailControler.text.trim();
      password = passwordControler.text.trim();
      username = usernameControler.text.trim();
    });
    if (email != '' && password != '') {
      // Email & password are not null
      if (destination == AuthPages.signUp) {
        // It is sign up page
        if (username != '') {
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

  bool isNotAnon() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        return false;
      }
    }
    return true;
  }
}
