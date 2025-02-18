import 'package:flutter/material.dart';
import 'package:procal/pages/nav_pages/search_pages/food_search_page.dart';
import 'package:procal/pages/nav_pages/search_pages/main_explore_page.dart';
import 'package:procal/pages/nav_pages/home_page/main_home_page.dart';
import 'package:procal/pages/nav_pages/home_page/profile_page.dart';
import 'package:procal/pages/nav_pages/progress_page/main_progress_page.dart';
import 'package:procal/pages/nav_pages/schedule_page/main_schedule_page.dart';
import 'package:google_fonts/google_fonts.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPageIndex = 0;

  final List pages = [
    const HomePage(),
    const ExplorePage(),
    const SchedulePage(),
    const ProgressPage(),
  ];

  final List<Widget> myDestinations = const [
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'Explore'),
    NavigationDestination(icon: Icon(Icons.list_alt), label: 'Schedule'),
    NavigationDestination(icon: Icon(Icons.trending_up), label: 'Progress'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text(
          'PROCAL',
            style: GoogleFonts.audiowide(
          ),
        ),
        centerTitle: true,
        
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {

          },
        ),
    
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())),
            icon: const Icon(Icons.account_circle),
          )
        ],
      ), 

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const FoodSearchPage()),
          );
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.search),
      ),
      
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey[200],
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
