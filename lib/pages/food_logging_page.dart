// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class FoodLoggingPage extends StatelessWidget {
  const FoodLoggingPage({super.key, required this.food});

  final Map<String, dynamic> food;


  int? getNutrientIndex(String nutriName) {
    List nutrients = food["foodNutrients"] ?? [];

    for (int i = 0; i < nutrients.length; i++) {
      if (nutrients[i]["nutrient"]["name"] == nutriName) {
        return i;
      }
    }
    print("No such field");
    return null;
  }

  String getName() {
    return food["description"] ?? "Nameless";
  }

  String getCategory() {
    return food["foodCategory"]["description"] ?? "No category";
  }

  num getDefaultNutrientValue(String nutriName) {
    int? nutriIndex = getNutrientIndex(nutriName);
    return food["foodNutrients"][nutriIndex]["amount"] ?? 0;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(getName()),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Food catagory: ${getCategory()}"),
            Text("Food calories: ${getDefaultNutrientValue("Energy")}"),
            Text("Food protein: ${getDefaultNutrientValue("Protein")}"),
          ],
        ),
      ),
    );
  }
}