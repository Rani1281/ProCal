import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procal/widgets/my_text_field.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({super.key});

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {
  final List _foods = ['Egg', 'Pizza', 'Pasta'];
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
            Expanded(
              child: ListView.builder(
                  itemCount: _foods.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ListTile(
                        title: Text(_foods[index]),
                        subtitle: Text('86 calories, 6.2g protein'),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
