import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:procal/components/main_navigation.dart';
import 'package:procal/pages/auth_pages/main_auth.dart';
import 'package:procal/pages/nav_pages/home_page/main_home_page.dart';
import 'package:procal/pages/auth_pages/verify_email_page.dart';
import 'package:procal/models/auth_page_design.dart';
import 'package:procal/services/firebase_firestore.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'PROCAL',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          else if (snapshot.hasData) {
            print('Logged in as: ${_auth.currentUser?.uid}');
            // User is signed in
            if (_auth.currentUser!.providerData.any((provider) => provider.providerId == 'password')) {
              // The user is signed with email & password provider
              if(!_auth.currentUser!.emailVerified) {
                // User email is NOT verified
                return const VerifyEmailPage();
              } 
            }
            return const MainNavigation();   
          } 
          // User is NOT signed in
          //return AuthPage(destination: 'sign-up');
          return const MainAuthPage(destination: AuthPages.signUp);
        },
      ),
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
    );
  }
}


