import 'package:flutter/material.dart';
import 'package:untitled6/post_item.dart';
import 'package:untitled6/sold.dart';
import 'package:untitled6/soldOut.dart';
import 'package:untitled6/stall.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;
  final screens = [
    EnterPost(),
    const BoughtView(),
    const Sold(),
    const SoldOut()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Item",
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "Sold",
              backgroundColor: Colors.amber),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: "SoldOut",
              backgroundColor: Colors.deepPurple)
        ],
      ),
    );
  }
}
