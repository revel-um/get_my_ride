import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.location_on,
          color: MyColors.primaryColor,
        ),
        title: Text(
          '',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.black,
            fontSize: 16,
            decorationStyle: TextDecorationStyle.dashed,
          ),
        ),
      ),
    );
  }
}
