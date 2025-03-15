import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FirestoreService {

  final _firestore = FirebaseFirestore.instance;

  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String email, String username, String userId) async {
    
    final userInfo = {
      'email': email,
      'username': username,
    };
    await usersCollection.doc(userId).set(userInfo)
    .onError((e, _) => print('An error accured: $e'));
  }

  Future<void> addUserFromDoc(DocumentSnapshot? doc, String id) async {
    if (doc != null) {
      await usersCollection.doc(id).set(doc.data() as Map<String, dynamic>);
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      print("User information deleted");
    } on FirebaseException catch (e) {
      print("Firebase ex: ${e.message}");
    } catch (e) {
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

  Future<DocumentReference<Object?>>? addDoc(
      String collectionName, Object? data) {
    CollectionReference collection = _firestore.collection(collectionName);
    try {
      final docRef = collection.add(data);
      print('Document added!');
      return docRef;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Get foods in firestore from a search parameter
  Future<List<Map<String,dynamic>>> searchFood(String searchStr) async {
    try {
      final foodsCollection = _firestore.collection('foods');

      // Later change to where method (and adding a lowercase field to each food)
      QuerySnapshot querySnapshot = await foodsCollection
      .where('search_name', isGreaterThanOrEqualTo: searchStr.toLowerCase())
      .limit(50)
      .get();
      
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print("An error accured: $e");
      return [];
    }
    
  }


  // void printAllCategories() async {
  //   List<String> allCategories = [];
  //   _firestore.collection("foods").get().then(
  //     (querySnapshot) {
  //       print('GOT ALL DOCS!');
  //       for(var docSnapshot in querySnapshot.docs) {
  //         final doc = docSnapshot.data();
  //         final categoryName = doc['foodCategory']?['description'];
  //         if (!allCategories.contains(categoryName) && categoryName != null) {
  //           allCategories.add(categoryName);
  //           print(categoryName);
  //         }
  //       }
  //     },
  //     onError: (e) => print("Error completing: $e")
  //   );
  // }


//   Future<void> addLowercaseName() async {
//   const int batchSize = 50; // Adjust as needed
//   QuerySnapshot<Map<String, dynamic>>? lastBatch;
//   int updated = 0;

//   try {
//     do {
//       var query = _firestore
//           .collection('foods')
//           .orderBy(FieldPath.documentId)
//           .limit(batchSize);

//       // If this isn't the first batch, start after the last document of previous batch
//       if (lastBatch != null && lastBatch.docs.isNotEmpty) {
//         query = query.startAfterDocument(lastBatch.docs.last);
//       }

//       lastBatch = await query.get(); // Fetch next batch
//       WriteBatch batch = FirebaseFirestore.instance.batch();

//       for (var doc in lastBatch.docs) {
//         var data = doc.data();
//         if (!data.containsKey('lowercaseName')) {
//           var description = data['description'];
//           if (description != null && description is String) {
//             String lowercaseName = description.toLowerCase();
//             batch.update(doc.reference, {'lowercaseName': lowercaseName}); // Modify as needed
//             updated++;
//           } else {
//             print('Document ${doc.id} does not have a valid description field.');
//           }
//         }
//       }

//       await batch.commit(); // Apply updates in batch
//       await Future.delayed(Duration(milliseconds: 500)); // Short delay to avoid Firestore rate limits

//     } while (lastBatch.docs.length == batchSize); // Continue if more documents exist

//     print("A TOTAL OF $updated DOCUMENTS WERE UPDATED");
//   } catch (e) {
//     print('An error occurred during the batch update: $e');
//   }
// }

  
}
