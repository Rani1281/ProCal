import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            // Text field (search food)

            // List
          ],
        ),
      ),
    );
  }
}
