import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/components/my_text_field.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {

  final TextEditingController _foodSearchController = TextEditingController();

  final FirestoreService _firestore = FirestoreService();

  List<Map<String, dynamic>> foods = [];

  bool isLoading = false;
  bool isSearchNotEmpty = false;
  

  Future<void> search(String searchStr) async {
    searchStr = searchStr.trim();
    if(searchStr.isNotEmpty) {
      setState(() {
        isSearchNotEmpty = true;
        isLoading = true;
      });
      try {
        final results = await _firestore.searchFood(searchStr);
        if(results.isNotEmpty) {
          setState(() {
            foods = filterResults(results, searchStr);
          });
        }
        isLoading = false;
        print('Search was successful!');
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('An error occurred during the search: $e');
      }
      
    }
    // Display the logging history
  }

  List<Map<String, dynamic>> filterResults(List<Map<String, dynamic>> results, String searchedFood) {
    return results.where((result) {
      String foodName = result['lowercaseName'] ?? '';
      foodName = foodName.replaceAll(',', '');
      return foodName.contains(searchedFood.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyTextField(
          controller: _foodSearchController,
          hintText: 'Search a food...',
          endIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          sumbitType: TextInputAction.search,
          onSubmitted: (input) {
            input.trim;
            print('Submitted!');
            search(input);
          },
          autofocus: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // List
            isSearchNotEmpty
            ?  isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
              : Expanded(
                child: Column(
                  children: [
                    foods.isNotEmpty
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Search results', style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(foods.length.toString())
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('No results', style: TextStyle(fontWeight: FontWeight.bold),),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Report food',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue,
                            ),
                            
                          ),
                        )
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: foods.length,
                        itemBuilder: (context, i) {
                          final food = foods[i];
                          final description = food['description'] ?? 'No description';
                          final category = food['foodCategory']['description'] ?? 'Other foods';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(description),
                              subtitle: Text(category),
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              trailing: const Icon(Icons.add),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const Text('Search a food')
          ],
        ),
      ),
    );
  }
}
