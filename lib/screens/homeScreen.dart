import 'package:flutter/material.dart';
import 'package:quick_bite/screens/navigationTabs/searchTab.dart';

import 'navigationTabs/homeTab.dart';
import 'navigationTabs/mapTab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navigationIndex = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(
            () {
              navigationIndex = index;
            },
          );
        },
        currentIndex: navigationIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Favorites',
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'Map',
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
          ),
        ],
        elevation: 10,
      ),
      body: getFragment(index: navigationIndex),
    );
  }

  void changeTab(int index) {
    setState(() {
      navigationIndex = index;
    });
  }

  void changeLoadingStatus(bool status) {
    setState(() {
      isLoading = status;
    });
  }

  Widget getFragment({index}) {
    switch (index) {
      case 0:
        return HomeTab(
          changeTab: changeTab,
          changeLoadingStatus: changeLoadingStatus,
        );
      case 1:
        return SearchTab();
      case 2:
        return MapTab();
      default:
        return HomeTab(
          changeTab: changeTab,
          changeLoadingStatus: changeLoadingStatus,
        );
    }
  }
}
