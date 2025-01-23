
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

    final usersCollection = FirebaseFirestore.instance.collection('users');

    Future<void> addUser(String email, String username, String userId) async {
      try {
        DocumentSnapshot doc = await usersCollection.doc(userId).get();
        if(!doc.exists) {
          print('This document does not exist');
          await usersCollection.doc(userId).set({
            'email' : email,
            'username' : username,
          });
        }
        
      } catch (e) {
        print(e);
      }
    }

    Future<void> deleteUser(String userId) async {
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).delete();
        print("User information deleted");
      } on FirebaseException catch(e) {
        print("Firebase ex: ${e.message}");
      }
      catch (e) {
        print(e.toString());
      }
      
    }
}