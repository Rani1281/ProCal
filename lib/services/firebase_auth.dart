import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up
  Future<User?> createAccountWithEmailAndPassword(String email, String password) async {
    String errorMessage = '';

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak';
      }
      else if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use';
      }
      else {
        errorMessage = e.message ?? 'An error occured while creating the account';
      }
      Fluttertoast.showToast(msg: errorMessage, webPosition: 'center');
      return null;
    } catch (e) {
      print(e);
      return null;
    } 
    
  }

  // Sign in
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    String errorMessage = '';

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email';
      }
      else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user';
      }
      else {
        errorMessage = e.message ?? 'An error occured while signing in';
      }
      Fluttertoast.showToast(msg: errorMessage, webPosition: 'center');
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  
  // Add more exeptions

  // Future<void> deleteAccount() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   await user?.reauthenticateWithCredential(credential)
  //   await user?.delete();
  // } 
}