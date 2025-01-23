import 'package:flutter/material.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/widgets/auth_page_design.dart';
import 'package:procal/widgets/my_toast.dart';

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
  final MyMoast myToast = MyMoast();

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
      AuthPages.signUp : AuthPageDesign(
        title: 'Sign Up',
        onPressed: () async => await _auth.createAccountWithEmailAndPassword(email, password, username),
        buttonText: 'Create Account',
        bottomText: 'Already have an account? Log In',
        bottomTextDestination: AuthPages.logIn,
      ),
      AuthPages.logIn : AuthPageDesign(
        title: 'Log In',
        onPressed: () async => await _auth.signInWithEmailAndPassword(email, password),
        buttonText: 'Log In',
        bottomText: "Don't have an account? Sign Up",
        bottomTextDestination: AuthPages.signUp,
      ),
      AuthPages.reAuth : AuthPageDesign(
        title: 'Re-Log',
        onPressed: () async => await _auth.reauthenticate(email, password),
        buttonText: 'Re-Log'
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [

            destination == AuthPages.signUp
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
                if(formIsFilled()) {
                  // Activate this page's function
                  thisPage.onPressed();
                }
                else {
                  myToast.show('Please fill all the fields before continuing');
                }
              },
              child: Text(thisPage.buttonText)
            ),
            // Have an account
            const SizedBox(height: 15),
            thisPage.bottomTextDestination != null
            ? InkWell(
                onTap: () {
                  setState(() {
                    destination = thisPage.bottomTextDestination!;
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

  // Checks if the input is null or not. If it is - returns false, Else - returns true
  bool formIsFilled() {
    setState(() {
      email = emailControler.text.trim();
      password = passwordControler.text.trim();
      username = usernameControler.text.trim();
    });
    if(email != '' && password != '') {
      // Email & password are not null
      if(destination == AuthPages.signUp) {
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