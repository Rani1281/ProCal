import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AuthService {

  Future<void> createUserAccount(String email, String password) async {
    String errorMessage = '';

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak';
      }
      else if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use';
      }
      else {
        errorMessage = 'Something went wrong';
      }
      showToast(errorMessage);
    } catch (e) {
      print(e);
    }   
  }

  // Future<void> deleteAccount() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   await user?.reauthenticateWithCredential(credential)
  //   await user?.delete();
  // } 
}