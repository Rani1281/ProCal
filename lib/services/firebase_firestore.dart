import 'package:cloud_firestore/cloud_firestore.dart';

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
  Future<List<Map<String,dynamic>>> searchFood(String? searchStr) async {
    final foodsCollection = _firestore.collection('foods');
    if(searchStr != null) {
      // QuerySnapshot querySnapshot = await foodsCollection
      // .where('description'.toLowerCase(), isGreaterThanOrEqualTo: searchStr)
      // .where('description'.toLowerCase(), isLessThan: searchStr + 'z')
      // .limit(20)
      // .get();

      //return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      QuerySnapshot querySnapshot = await foodsCollection.get();
      
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>)
        .where((food) {
          String foodName = (food['description']);
          foodName = foodName.toLowerCase();
          return foodName.contains(searchStr.toLowerCase());
        }).toList();
    }
    else {
      QuerySnapshot querySnapshot = await foodsCollection.limit(20).get();
      
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    }
    
  }
}
