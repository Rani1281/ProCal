import 'package:firebase_auth/firebase_auth.dart';
import 'package:procal/services/firebase_auth.dart';

class AuthPageDesign {
  AuthPageDesign({required this.title, required this.onPressed, required this.buttonText, this.bottomText, this.bottomTextDestination});

  final String title;
  final void Function() onPressed;
  final String buttonText;
  final String? bottomText;
  final AuthPages? bottomTextDestination;

}

enum AuthPages {
  signUp,
  logIn,
  reAuth,
  upgrade,
}