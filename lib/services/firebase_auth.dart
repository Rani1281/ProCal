// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/widgets/my_toast.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();
  final MyMoast toast = MyMoast();

  // Sign up
  Future<void> createAccountWithEmailAndPassword(String email, String password, String username) async {
    String errorMessage;

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      if (userCredential.user != null) {
        toast.show('Account has been created successfuly');
        await _firestore.addUser(
          email,
          username,
          userCredential.user!.uid,
        );
      } else {
        print('USER NOT CREATED');
      }
      // return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'weak-password':
          errorMessage = 'The password is too weak';
        break;
        case 'email-already-in-use':
          errorMessage = 'This email is already in use';
        break;
        case 'invalid-email':
          errorMessage = 'Email is invalid';
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
      toast.show(errorMessage);
      // return null;
    } catch (e) {
      print(e);
      // return null;
    } 
  }

  // Sign in
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    String errorMessage = '';

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      if(userCredential.user != null) {
        toast.show('Welcome back!');
      }
      // return userCredential.user;
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case 'user-not-found':
          errorMessage = 'User not found';
        break;
        case 'wrong-password':
          errorMessage = 'Password is incorrect';
        break;
        case 'invalid-email':
          errorMessage = 'Email is invalid';
        break;
        case 'user-disabled':
          errorMessage = "This user was disabled";
        break;
        case 'network-request-failed':
          errorMessage = 'No internet connection';
        break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later';
        break;
        case 'INVALID_LOGIN_CREDENTIALS' || 'invalid-credential':
          errorMessage = 'Invalide email or password';
        break;
        default:
          errorMessage = 'Something went wrong';
          print(e.message);
        break;
      }
      toast.show(errorMessage);
      // return null;
    } catch (e) {
      print(e);
      // return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: "Signed out successfuly", gravity: ToastGravity.CENTER);
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


}