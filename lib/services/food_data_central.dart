import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FoodDataCentral {
  final String jsonFilePath;

  FoodDataCentral(this.jsonFilePath);

  Future<List<Map<String, dynamic>>?> convertJson() async {
    try {
      String jsonString = await File(jsonFilePath).readAsString();
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract the list of foods
      final List foodList = jsonData['SRLegacyFoods'];

      print("Conversion successful!");

      return foodList as List<Map<String, dynamic>>;
    } catch (e) {
      print("Error during JSON conversion: $e");
    }
    return null;
  }

  Future<void> uploadFoodsToFirestore() async {
    var foods = await convertJson();

    if (foods != null) {
      // Split the list into chunks of 500
      List<List<Map<String, dynamic>>> chunks = [];
      int chunkSize = 500;

      for (var i = 0; i < foods.length; i += chunkSize) {
        chunks.add(foods.sublist(i, i + chunkSize > foods.length ? foods.length : i + chunkSize));
      }

      // Upload each chunk to Firestore
      for (var chunk in chunks) {
        WriteBatch batch = FirebaseFirestore.instance.batch();

        for (var food in chunk) {
          // Add the this field before uploading to Firestore
          addMoreSearchableField(food);
          DocumentReference docRef = FirebaseFirestore.instance.collection('foods_info').doc();
          batch.set(docRef, food);
        }

        try {
          await batch.commit();
        } catch (e) {
          print("Error during batch commit: $e");
        }
      }

      print("Upload successful!");
    } else {
      print("No foods to upload.");
    }
  }

  void addMoreSearchableField(Map<String, dynamic> food) {
    if (food.containsKey('description') && !food.containsKey('queryName')) {
      if (food['description'] is String) {
        String lowercaseName = food['description'].toLowerCase();
        String lowercaseAndUnseparated = lowercaseName.replaceAll(RegExp(r'[^\w\s]'), '');
        food['queryName'] = lowercaseAndUnseparated;
      }
    }
  }
}