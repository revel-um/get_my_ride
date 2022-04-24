import 'package:flutter/material.dart';
import 'package:quick_bite/apis/AllApis.dart';

import 'navigationTabs/cartTab.dart';
import 'navigationTabs/ordersTab.dart';
import 'navigationTabs/homeTab.dart';

class HomeScreen extends StatefulWidget {
  final navigationIndex;

  const HomeScreen({this.navigationIndex = 0});

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
        selectedItemColor: Colors.black,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 14),
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
            icon: Icon(
              Icons.home_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(Icons.home, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Cart',
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(Icons.shopping_bag, color: Colors.black),
          ),
          BottomNavigationBarItem(
            label: 'Orders',
            icon: Icon(
              Icons.analytics_outlined,
              color: Colors.black,
            ),
            activeIcon: Icon(Icons.analytics, color: Colors.black),
          ),
        ],
        elevation: 10,
      ),
      body: getFragment(index: navigationIndex),
    );
  }

  @override
  void initState() {
    super.initState();
    navigationIndex = widget.navigationIndex;
    AllApis.staticContext = context;
    AllApis.staticPage = HomeScreen();
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
        return CartTab();
      case 2:
        return OrdersTab();
      default:
        return HomeTab(
          changeTab: changeTab,
          changeLoadingStatus: changeLoadingStatus,
        );
    }
  }
}
