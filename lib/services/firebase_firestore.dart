
import 'package:cloud_firestore/cloud_firestore.dart';


class FirestoreService {

  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<DocumentSnapshot?> addUser(String email, String username, String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if(!doc.exists) {
        print('This document does not exist');
        // Create a new document
        await usersCollection.doc(userId).set({
          'email' : email,
          'username' : username,
        });
        return doc;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> addUserFromDoc(DocumentSnapshot? doc, String id) async {
    if(doc != null) {
      await usersCollection.doc(id).
      set(doc.data() as Map<String, dynamic>);
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

  Future<DocumentSnapshot?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      return doc;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
  
}