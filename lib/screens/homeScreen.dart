import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_bite/screens/navigationTabs/searchTab.dart';

import 'navigationTabs/favoriteTab.dart';
import 'navigationTabs/homeTab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int navigationIndex = 0;

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
            label: 'Favorite',
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(
              Icons.favorite,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
          ),
        ],
        elevation: 10,
      ),
      body: getFragment(index: navigationIndex),
    );
  }

  Widget getFragment({index}) {
    switch (index) {
      case 0:
        return HomeTab();
      case 1:
        return FavoriteTab();
      case 2:
        return SearchTab();
      default:
        return HomeTab();
    }
  }
}
