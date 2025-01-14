import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:procal/pages/home_page.dart';
import 'package:procal/pages/login_page.dart';
import 'package:procal/pages/verify_email_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProCal',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasData) {
            // User is signed in
            if(_auth.currentUser!.emailVerified) {
              // User email is verified
              return const HomePage();
            }
            else if(!_auth.currentUser!.emailVerified) {
              // User email is NOT verified
              return const VerifyEmailPage();
            } 
          } 
          // User is NOT signed in
          return const LoginPage();
        },
      ),
    );
  }
}


// class AuthStateListener extends StatefulWidget {
//   const AuthStateListener({super.key});

//   @override
//   State<AuthStateListener> createState() => _AuthStateListenerState();
// }

// class _AuthStateListenerState extends State<AuthStateListener> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//     stream: FirebaseAuth.instance.idTokenChanges(),
//     builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasData) {
//           // User is signed in
//           print('User is signed in!');
//           return const HomePage();
//         } else {
//           // User is not signed in
//           print('User is currently signed out!');
//           return const SignupPage();  
//         }
//     }
//     );
//   }
// }


