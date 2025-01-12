
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

    final usersCollection = FirebaseFirestore.instance.collection('users');

    Future<void> addUser(String email, String username, String userId) async {
        try {
            await usersCollection.doc(userId).set({
                'email': email,
                'username': username,
            });
        } catch (e) {
            print(e);
        }
    }

    Future<void> deleteUser(String userId) async {
        await FirebaseFirestore.instance.collection('users').doc(userId).delete();
    }
}