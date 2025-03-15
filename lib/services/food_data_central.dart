import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class FoodDataCentral {
  final String jsonFilePath;
  final String jsonDataKey;

  FoodDataCentral(this.jsonFilePath, this.jsonDataKey);

  Future<void> uploadFoodsToFirestore() async {
    try {
      ByteData data = await rootBundle.load(jsonFilePath);
      String jsonString = utf8.decode(data.buffer.asUint8List());

      print("Decoding successful!");

      // Process the JSON string in chunks
      final jsonData = json.decode(jsonString);
      if (jsonData.containsKey(jsonDataKey)) {
        // Extract
        List<Map<String, dynamic>> foodList = List<Map<String, dynamic>>.from(jsonData[jsonDataKey]);
        print("Extraction successful!");

        // Upload each food item individually with rate limiting
        for (var food in foodList) {
          await _uploadFood(food);
          await Future.delayed(Duration(milliseconds: 100)); // Rate limit: 10 writes per second
        }

        print("Upload successful!");
      } else {
        print("No foods to upload.");
      }
    } catch (e) {
      print("Error during JSON conversion or upload: $e");
    }
  }

  Future<void> _uploadFood(Map<String, dynamic> food) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      addMoreSearchableField(food);
      DocumentReference docRef = FirebaseFirestore.instance.collection('foods').doc();
      batch.set(docRef, food);
      await batch.commit();
      print('Uploaded food item successfully');
    } catch (e) {
      print('Error uploading food item: $e');
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