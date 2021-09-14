// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:life_easy/screens/home_screen.dart';

class MyBottomNavigation extends StatefulWidget {
  final String title;
  static const routeName = 'bottom-navigation';
  MyBottomNavigation({Key? key, required this.title}) : super(key: key);
  
  @override
  _MyBottomNavigationState createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  int currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 8,
        curve: Curves.easeInBack,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.verified_user),
            title: Text('Profile'),
            activeColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.search),
            title: Text('Search'),
            activeColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.help),
            title: Text('Help'),
            activeColor: Colors.black,
            textAlign: TextAlign.center,
          ),
          // BottomNavyBarItem(
          //   icon: Icon(Icons.account_circle),
          //   title: Text('Users'),
          //   activeColor: Colors.black,
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
