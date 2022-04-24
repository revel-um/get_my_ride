import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_bite/apis/AllApis.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/globalsAndConstants/networkChecker.dart';

import 'homeScreen.dart';

class OfflinePage extends StatefulWidget {
  final comingFrom;
  final serverIssue;

  OfflinePage({@required this.comingFrom, this.serverIssue = false});

  @override
  _OfflinePageState createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  bool serverIssue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svgs/error.svg',
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            serverIssue
                ? 'Server down please try after sometime'
                : 'No Internet connection ❌',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => widget.comingFrom),
              );
            },
            child: Icon(
              Icons.refresh_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (AllApis.staticPage.runtimeType == HomeScreen)
      AllData.addressData = null;
    serverIssue = widget.serverIssue;
    checkNet();
  }

  void checkNet() async {
    if (await NetworkCheckingClass().hasNetwork()) {
      setState(() {
        serverIssue = true;
      });
    } else {
      setState(() {
        serverIssue = false;
      });
    }
  }
}
