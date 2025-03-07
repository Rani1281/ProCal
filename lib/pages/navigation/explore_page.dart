import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:procal/components/food_catagory_item.dart';
import 'package:procal/components/my_text_field.dart';
import 'package:procal/pages/navigation/food_search_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              // Search bar
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FoodSearchPage())
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Search for a food',
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                      const Icon(
                        Icons.search,
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
          
          // Catagories
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildListDelegate([
              // Should change the pictures later
              const FoodCatagoryItem(imgPath: 'assets/steak.jpeg', text: 'Meat'),
              const FoodCatagoryItem(imgPath: 'assets/Dairy.jpg', text: 'Dairy'),
              const FoodCatagoryItem(imgPath: 'assets/Grains.jpg', text: 'Grains'),
              const FoodCatagoryItem(imgPath: 'assets/Fruits-and-vegetables.jpg', text: 'Grains'),
            ]),
          ),
        ],
      ),
    );
  }
}