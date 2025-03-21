// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/models/my_toast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final MyToast toast = MyToast();


  // Get user id

  String? getUserID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }


  // Sign up With Email And Password
  Future<User?> createAccountWithEmailAndPassword(String email, String password) async {
    String errorMessage;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      return userCredential.user;
      
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
          errorMessage = 'Something went wrong';
          print(e.message);
        break;
      }
    } catch (e) {
      print(e.toString());
      errorMessage = 'Something went wrong';
    }
    MyToast.show(errorMessage);
    return null; 
  }


  // Log in With Email And Password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    String errorMessage;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      print('Logged in as: ${userCredential.user?.uid}');
      return userCredential.user;

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
          errorMessage = 'Something went wrong';
          print(e.message);
        break;
      }
    } catch (e) {
      print(e.toString());
      errorMessage = 'Something went wrong';
    }
    MyToast.show(errorMessage);
    return null;
  }


  // Anonymous sign in 

  Future<User?> signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      MyToast.show('Logged in successfuly!');
      print('Logged in anonymously as: ${userCredential.user?.uid}');
      return userCredential.user;
    } on FirebaseAuthException {
      MyToast.show('Something went wrong. Please try again');
    } catch (e) {
      print(e.toString());
    }
    return null;
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
      MyToast.show(er);
    } catch (e) {
      print(e.toString());
    }
  }



  // Google sign in

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // User canceled the sign-in
    if(googleUser == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
      return cred.user;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Sign out

  Future<void> signOut() async {
    await _auth.signOut();
    MyToast.show('Signed out successfuly');
  }

  Future<void> signOutGoogle() async {
    await GoogleSignIn().signOut();
    MyToast.show('Signed out successfuly');
  }


  // Delete the user

  // Future<List?> deleteUserAccount() async {
  //   String? errorMessage;
  //   String? errorCode;
  //   final user = _auth.currentUser;

  //   if(user != null) {

  //     DocumentSnapshot? userDetailsBackup = await _firestore.getUser(user.uid);

  //     user.reload();
  //     try {
  //       await _firestore.deleteUser(user.uid); // Delete user details
  //       await user.delete(); // Then delete user authentication
  //       MyToast.show('Account has been deleted successfuly');
  //       return [true];
  //     } on FirebaseAuthException catch(e) {
  //       if (e.code == 'requires-recent-login') {
  //         print('The user must reauthenticate before this operation can be executed.');
  //         errorMessage = 'You must re-log in before deleting your account';
  //         errorCode = e.code;
  //       } 
  //       else if (e.code == 'network-request-failed') {
  //         //toast.show('No internet connection');
  //         print('No internet connection');
  //         errorMessage = 'No internet connection';
  //         errorCode = e.code;
  //       }
  //       else {
  //         //toast.show('Something went wrong. Please try again');
  //         print(e.message);
  //         errorMessage = 'Something went wrong';
  //       }
  //     } catch (e) {
  //       print(e.toString());
  //       errorMessage = 'Something went wrong';
  //     }

  //     _firestore.addUserFromDoc(userDetailsBackup, user.uid);  // Restore user details again

  //     return [false, errorMessage];
  //     //DeleteUserResult(isSuccessful: false, errorMessage: errorMessage);
  //   }
    
  //   print('Failed to delete account because user is not authenticated');
  //   return null;
  // }

  // Log in user again
  Future<User?> reauthenticate(String email, String password) async {
    String errorMessage;

    User? user = _auth.currentUser;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      if(user != null) {
        UserCredential newUserCredential = await user.reauthenticateWithCredential(credential);
        return newUserCredential.user;
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
      MyToast.show(errorMessage);
    }
    catch(e) {
      print(e);
    }
    return null;
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


  void updateUsername(String newName) {
    _auth.currentUser?.updateDisplayName(newName);
  }


}