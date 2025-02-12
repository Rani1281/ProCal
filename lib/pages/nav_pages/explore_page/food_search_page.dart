import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/widgets/my_text_field.dart';
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

  List<Map<String, dynamic>>? foods;

  bool isLoading = false;
  

  Future<void> search(searchStr) async {
    setState(() {
      isLoading = true;
    });
    final results = await _firestore.searchFood(searchStr);
    setState(() {
      foods = results;
      isLoading = false;
    });
    
  } 

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    search(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // titleSpacing:
        //     0, // Decrease the spacing between the back icon and the title
        title: MyTextField(
          controller: _foodSearchController,
          hintText: 'Search a food...',
          endIcon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          sumbitType: TextInputAction.search,
          onSubmitted: (input) {
            print('Submitted!');
            search(input);

          } ,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // List
            isLoading
            ? CircularProgressIndicator()
            : Expanded(
                child: ListView.builder(
                  itemCount: foods!.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(foods![i]['description']) ,
                      subtitle: Text('Subtile'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
