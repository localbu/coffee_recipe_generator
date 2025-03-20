import 'package:flutter/material.dart';
import 'package:schedule_generator/screen/home/home_screen.dart';
import 'package:schedule_generator/screen/service/service_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indexPage = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _indexPage = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          ServiceScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexPage,
        onTap: _onItemTapped,
        backgroundColor: Colors.brown[800],
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.white70,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee),
            label: 'Recommendation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Service',
          ),
        ],
      ),
    );
  }
}
