import 'package:flutter/material.dart';
import 'package:procal/pages/food_logging_page.dart';
import 'package:procal/services/firebase_firestore.dart';


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
  
  // Search the database by array-contains-any
  void search(String input) async {
    if (input.isNotEmpty) {

      List<String> searchQueries = prepareInput(input);

      setState(() {
        isSearchNotEmpty = true;
        isLoading = true;
      });

      try {
        final results = await _firestore.searchFoodByArrayContainsAny(searchQueries);

        if (results.isNotEmpty) {
          setState(() {
            foods = results;
          });
        }
      } catch (e) {
        print('An error occurred during the search: $e');
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  // perform actions on the input to make it more queriable
  List<String> prepareInput(String input) {
    // trim
    input.trim();

    // lowercase
    input.toLowerCase();

    // remove symbols
    input.replaceAll('.', '');
    input.replaceAll(',', '');

    //split
    List<String> splittedInput = input.split(' ');
    
    return splittedInput;
  }



  // Future<void> searchOld(String searchStr) async {
  //   searchStr = searchStr.trim().toLowerCase();
  //   if(searchStr.isNotEmpty) {
  //     setState(() {
  //       isSearchNotEmpty = true;
  //       isLoading = true;
  //     });
  //     try {
  //       final results = await _firestore.searchFoodByGreaterThanOrEqualTo(searchStr);
        
  //       if(results.isNotEmpty) {
  //         setState(() {
  //           foods = filterSearchResults(results, searchStr);
  //         });
  //       }
  //       else {
  //         print("No results");
  //       }
  //       isLoading = false;
  //       print('Search was successful!');
  //     } catch (e) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       print('An error occurred during the search: $e');
  //     }
      
  //   }
  //   // Display the logging history
  // }

  // List<Map<String, dynamic>> filterSearchResults(List<Map<String, dynamic>> results, String searchStr) {
  //   List<Map<String, dynamic>> filteredResults = [];

  //   for (var result in results) {
  //     if (result.containsKey("search_name")) {

  //       bool isFound = listContains(result, searchStr);

  //       if (isFound) {
  //         filteredResults.add(result);
  //         print('Removed item');
  //       }
  //     }
  //     else {
  //       print("Doesn't contain key");
  //     }
  //   }
  //   return filteredResults;
  // }

  // bool listContains(Map<String, dynamic> result, String searchStr) {
  //   searchStr.toLowerCase();

  //   String resultName = result["search_name"];
  //   List<String> resultWords = resultName.split(' ');
  //   List<String> searchWords = searchStr.split(' ');

  //   for (var searchWord in searchWords) {
  //     for (var resultWord in resultWords) {
  //       if (searchWord == resultWord || resultWord.contains(searchWord)) {
  //         return true;
  //       }
  //     }
  //   }
  //   return false;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: TextField(
          controller: _foodSearchController,
          onSubmitted: (input) {
            input.trim;
            print('Submitted!');
            search(input);
          },
          decoration: InputDecoration(
            filled: false,
            hintText: "Search a food...",
            prefixIcon: IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back)),
            suffixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ),
          autofocus: true,
          textInputAction: TextInputAction.search,
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
                          final description = food['description'] ?? 'Nameless';
                          final category = food['foodCategory']['description'] ?? 'No category';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              child: ListTile(
                                title: Text(description),
                                subtitle: Text(category),
                                tileColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                trailing: const Icon(Icons.add),
                              ),
                              onTap: () => goToFoodLoggingPage(context, food),
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

  void goToFoodLoggingPage(BuildContext contex, Map<String, dynamic> food) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FoodLoggingPage(food: food),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);  // Slide from right to left
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
