import 'package:flutter/material.dart';
import 'package:procal/pages/nav_pages/search_pages/food_search_page.dart';
import 'package:procal/pages/nav_pages/search_pages/main_explore_page.dart';
import 'package:procal/pages/nav_pages/home_page/main_home_page.dart';
import 'package:procal/pages/nav_pages/home_page/profile_page.dart';
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
    0: const HomePage(),
    1: const ExplorePage(),
    2: const SchedulePage(),
    3: const ProgressPage(),
  };

  final List<Widget> myDestinations = const [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explore'),
    NavigationDestination(icon: Icon(Icons.list_alt), label: 'Schedule'),
    NavigationDestination(icon: Icon(Icons.trending_up), label: 'Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('PROCAL'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FoodSearchPage()));
                },
                icon: Icon(Icons.search))
          ],
          leading: IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage())),
            icon: Icon(Icons.account_circle),
          )),
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
