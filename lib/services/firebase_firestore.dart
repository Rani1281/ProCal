import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:procal/components/food_catagory_item.dart';

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
    final foodsCollection = _firestore.collection('foods');

    QuerySnapshot querySnapshot = await foodsCollection.get();
    
    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>)
      .where((food) {
        String foodName = (food['description'] ?? 'Empty');
        foodName = foodName.toLowerCase();
        return foodName.contains(searchStr.toLowerCase());
      }).toList();
  }

  // Future<void> uploadJsonToFirestore() async {

  //   final foodCollection = FirebaseFirestore.instance.collection('foods');

  //   if(user != null) {
  //     print('The user is authenticated');
  //   } else {
  //     print('The user is not authenticated');
  //   }

  //   try {
  //     String jsonString = await rootBundle.loadString('assets/foundationDownload.json');
  //     final Map<String, dynamic> jsonData = json.decode(jsonString);

  //     // Extract the list of foods
  //     final List<dynamic> foodList = jsonData["FoundationFoods"];

  //     for (var food in foodList) {
  //       await foodCollection.add(food);
  //     }

  //     print("Uploaded successfuly!");
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  void printAllCategories() async {
    List<String> allCategories = [];
    _firestore.collection("foods").get().then(
      (querySnapshot) {
        print('GOT ALL DOCS!');
        for(var docSnapshot in querySnapshot.docs) {
          final doc = docSnapshot.data();
          final categoryName = doc['foodCategory']?['description'];
          if (!allCategories.contains(categoryName) && categoryName != null) {
            allCategories.add(categoryName);
            print(categoryName);
          }
        }
      },
      onError: (e) => print("Error completing: $e")
    );
  }
}
