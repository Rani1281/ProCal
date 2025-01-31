// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/widgets/my_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();
  final MyMoast toast = MyMoast();

  // Sign up With Email And Password
  Future<void> createAccountWithEmailAndPassword(String email, String password, String username) async {
    String errorMessage;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      if(userCredential.user != null) {
        userCredential.user?.updateDisplayName(username);
        await _firestore.addUser(
          email,
          username,
          userCredential.user!.uid,
        );
      }
      print('Logged in anonymously as: ${userCredential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak';
        break;
        case 'email-already-in-use':
          errorMessage = 'The email is already taken';
        break;
        case 'invalid-email':
          errorMessage = 'The email is invalid';
        break;
        case 'network-request-failed':
          errorMessage = 'No internet connection';
        break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later';
        break;
        default:
          errorMessage = 'Something went wrong. Please try again';
          print(e.message);
        break;
      }
      toast.show(errorMessage);
    } catch (e) {
      print(e.toString());
    } 
  }

  // Log in With Email And Password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    String errorMessage = '';

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      toast.show('Welcome back!');
      print('Logged in anonymously as: ${userCredential.user?.uid}');
      // return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'user-not-found':
          errorMessage = "The user doesn't exist";
        break;
        case 'wrong-password':
          errorMessage = 'The password is incorrect';
        break;
        case 'invalid-email':
          errorMessage = 'The email is invalid';
        break;
        case 'user-disabled':
          errorMessage = "The user was disabled";
        break;
        case 'network-request-failed':
          errorMessage = 'No internet connection';
        break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later';
        break;
        case 'INVALID_LOGIN_CREDENTIALS' || 'invalid-credential':
          errorMessage = 'Invalid email or password';
        break;
        default:
          'Something went wrong. Please try again';
          print(e.message);
        break;
      }
      toast.show(errorMessage);
    } catch (e) {
      print(e);
    }
  }


  // Anonymous sign in 
  Future<void> signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      toast.show('Logged in successfuly!');
      print('Logged in anonymously as: ${userCredential.user?.uid}');
    } on FirebaseAuthException {
      toast.show('Something went wrong. Please try again');
    } catch (e) {
      print(e.toString());
    }
  }

  
  // Upgrade an anonymous account to a permanent account
  Future<void> upgradeAccountFromAnonToPermenant(String email, String password, String username) async {
    String er = '';

    // Email and password provider
    final credential = EmailAuthProvider.credential(
      email: email, password: password
    );

    try {
      UserCredential? userCredential =
       await _auth.currentUser?.linkWithCredential(credential);
      if(userCredential != null && userCredential.user != null) {
        // Update username
        userCredential.user?.updateDisplayName(username);
        // Add firestore user
        _firestore.addUser(
          email, username,
          userCredential.user!.uid
        );
      }
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'provider-already-linked':
          er = "The account is already connected to your profile";
        break;
        case 'invalid-credential':
          er = "The connection information isn't valid anymore";
        break;
        case 'credential-already-in-use':
          er = 'The account is already taken';
        break;
        case 'email-already-in-use':
          er = "The email is already taken";
        break;
        case 'wrong-password':
          er = "The password is incorrect";
        break;
        case 'invalid-email':
          er = "The email is invalid";
        break;
        case 'invalid-verification-code':
          er = "The phone verification code is invalid";
        break;
        default:
          er = "Somthing went wrong. Please try again";
          print(e.message);
        break;
      }
      toast.show(er);
    } catch (e) {
      print(e.toString());
    }
  }



  // Google sign in
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    
  }



  // Sign in with credential
  // Future<void> signInWithCredential(AuthCredential credential) async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //     if(userCredential.user != null) {
  //       //userCredential.user?.updateDisplayName();
  //       // await _firestore.addUser(
  //       //   email,
  //       //   username,
  //       //   userCredential.user!.uid,
  //       // );
  //     }
  //   } on FirebaseAuthException catch (e) {

  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }



  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      if(isSignedInWithGoogle()) {
        await GoogleSignIn().signOut();
      }
      toast.show('Signed out successfuly');
    } catch (e) {
      print(e);
    }
  }

  
  Future<int?> deleteUserAccount() async {
    FirebaseAuth.instance.currentUser!.reload();
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      toast.show('Account has been deleted successfuly');
      return 1;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'requires-recent-login') {
        print('The user must reauthenticate before this operation can be executed.');
        return 0;
      } 
      else if (e.code == 'network-request-failed') {
        toast.show('No internet connection');
      }
      else {
        toast.show('Something went wrong. Please try again');
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }


  Future<void> reauthenticate(String email, String password) async {
    String errorMessage = '';

    User? user = FirebaseAuth.instance.currentUser;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      if(user != null) {
        UserCredential newUserCredential = await user.reauthenticateWithCredential(credential);
        // The reauthentication succeeded
        // return true;

        if(newUserCredential.user != null) {
          user.reload();
          // Deletes user again
          _firestore.deleteUser(user.uid);  // THIS HAS TO BE FIRST
          deleteUserAccount();
          
          user = FirebaseAuth.instance.currentUser;

          if(user != null) {
            // The user still exists 
            int addSign = email.indexOf('@');
            String restoredUsername = email.substring(0, addSign);
            _firestore.addUser(email, restoredUsername, user.uid);
          }
          else {
            print('User deleted perminantly');
          }
        }
      }
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'user-mismatch':
        errorMessage = "The provided credential doesn't match yours";
        break;
        case 'user-not-found':
        errorMessage = 'User not found';
        break;
        case 'invalid-email':
        errorMessage = 'Email is invalid';
        break;
        case 'wrong-password':
        errorMessage = 'Password is incorrect';
        break;
        case 'network-request-failed':
        errorMessage = 'No internet connection';
        break;
        default:
        errorMessage = 'Something went wrong';
        print(e.message);
        break;
      }
      toast.show(errorMessage);
    }
    catch(e) {
      print(e);
    }
    // return false;
  }


  bool isSignedInWithGoogle() {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    for (var profile in user.providerData) {
      if (profile.providerId == 'google.com') {
        return true; // User signed in with Google
      }
    }
  }
  return false; // Not signed in or used a different provider
}


}