import 'package:flutter/material.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Food search page'));
  }
}