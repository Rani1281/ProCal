import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:procal/models/food_catagory_item.dart';
import 'package:procal/models/my_text_field.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: ListView(
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FoodCatagoryItem(text: 'Meats'),
              FoodCatagoryItem(text: 'Egg and Dairy')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FoodCatagoryItem(text: 'Grains'),
              FoodCatagoryItem(text: 'Legumes')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FoodCatagoryItem(text: 'Fruits & Vegetables'),
              FoodCatagoryItem(text: 'Others')
            ],
          ),
        ]
        
      )
    );
  }
}