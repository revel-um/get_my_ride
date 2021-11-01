import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quick_bite/globalsAndConstants/networkChecker.dart';

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
    final query = MediaQuery.of(context);
    final height = query.size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(height: height / 2 - 200),
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
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => widget.comingFrom),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Retry',
                        style: TextStyle(
                          color: Color(0xFFBA68C8),
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Icon(
                        Icons.refresh,
                        color: Color(0xFFBA68C8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
