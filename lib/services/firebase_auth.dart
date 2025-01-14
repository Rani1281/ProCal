import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirestoreService _firestore = FirestoreService();

  // Sign up
  Future<User?> createAccountWithEmailAndPassword(String email, String password) async {
    String errorMessage;

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
      else if (e.code == 'invalid-email') {
        errorMessage = 'Email is invalid';
      }
      else {
        errorMessage = e.message ?? 'Something went wrong';
      }
      Fluttertoast.showToast(msg: errorMessage);
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
      Fluttertoast.showToast(msg: errorMessage);
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
      Fluttertoast.showToast(msg: "Signed out successfuly");
    } catch (e) {
      print(e);
    }
  }

  
  Future<bool> deleteUserAccount() async {
    FirebaseAuth.instance.currentUser!.reload();
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch(e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
        // did not went well
        return false;
      } 
    }
    print("User deleted successfuly!");
    Fluttertoast.showToast(msg: "Your account has been deleted successfuly");
    // went well
    return true;
  }


  Future<bool> reauthenticate(String email, String password) async {

    final User? user = FirebaseAuth.instance.currentUser;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
      );
      if(user != null){
        await user.reauthenticateWithCredential(credential);
        print("User re-authenticated succesfully");
        // The reauthentication succeeded
        return true;
      }
    } on FirebaseAuthException catch(e) {
      Fluttertoast.showToast(msg: e.message ?? "An error accured");
    }
    catch(e) {
      print(e);
    }
    return false;
  }


}