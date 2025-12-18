import 'package:digital_elliptical/product_uplode_screens/add_product.dart';
import 'package:digital_elliptical/screens/favourite_screen.dart';
import 'package:digital_elliptical/screens/home_screen.dart';
import 'package:digital_elliptical/screens/notification_Screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final screens = [
    HomeScreen(),
  WishlistScreen(),
  // HomeScreen(),
    NotificationScreen(),
    AddProductScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 65, // Increase height to prevent overflow for larger icons
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.black,
          iconSize: 30, // Increase the icon size globally for all items
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '', // No label text
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: '', // No label text
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_active),
              label: '', // No label text
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_rounded),
              label: '', // No label text
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
      body: screens[_selectedIndex],
    );
  }
}
