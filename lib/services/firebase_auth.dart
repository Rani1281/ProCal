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
      Fluttertoast.showToast(msg: 'Account has been created successfuly!', gravity: ToastGravity.CENTER);
      return userCredential.user;
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
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.CENTER);
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
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.CENTER);
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
      Fluttertoast.showToast(msg: "Signed out successfuly", gravity: ToastGravity.CENTER);
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
    Fluttertoast.showToast(msg: "Account has been deleted successfuly", gravity: ToastGravity.CENTER);
    // went well
    return true;
  }


  Future<bool> reauthenticate(String email, String password) async {
    String errorMessage = '';

    final User? user = FirebaseAuth.instance.currentUser;

    try {
      AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
      );
      if(user != null) {
        await user.reauthenticateWithCredential(credential);
        print("User re-authenticated succesfully");
        // The reauthentication succeeded
        return true;
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
        default:
        errorMessage = 'Something went wrong';
        print(e.message);
        break;
      }
      Fluttertoast.showToast(msg: errorMessage, gravity: ToastGravity.CENTER);
    }
    catch(e) {
      print(e);
    }
    return false;
  }


}