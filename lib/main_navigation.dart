import 'package:flutter/material.dart';
import 'package:procal/pages/nav_pages/explore_page/food_search_page.dart';
import 'package:procal/pages/nav_pages/home_page/main_home_page.dart';
import 'package:procal/pages/nav_pages/progress_page/main_progress_page.dart';
import 'package:procal/pages/nav_pages/schedule_page/main_schedule_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int currentPageIndex = 0;

  final Map<int, Widget> pages = {
    0 : const HomePage(),
    1 : const FoodSearchPage(),
    2 : const SchedulePage(),
    3 : const ProgressPage(),
  };

  final List<Widget> myDestinations = const [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
    NavigationDestination(icon: Icon(Icons.list_alt), label: 'Schedule'),
    NavigationDestination(icon: Icon(Icons.trending_up), label: 'Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROCAL'),
        centerTitle: true,
        actions: const [
          Icon(Icons.search)
        ],
        leading: const Icon(Icons.account_circle),
      ),
      body: pages[currentPageIndex],

      bottomNavigationBar: NavigationBar(
        destinations: myDestinations,
        onDestinationSelected: (selectedIndex) {
          setState(() {
            currentPageIndex = selectedIndex;
          });
        },
        selectedIndex: currentPageIndex,
      ),
    );
  }
}