import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quick_bite/apis/AllApis.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/screens/homeScreen.dart';

class ChangeLocation extends StatefulWidget {
  final lat;
  final long;

  const ChangeLocation({this.lat, this.long});

  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {
  Timer? _debounce;

  List predictions = [];
  bool isLoading = false;
  int radius = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size(0, 2),
          child: isLoading
              ? LinearProgressIndicator(
                  minHeight: 2,
                )
              : Center(),
        ),
        title: TextField(
          autofocus: true,
          cursorColor: Colors.black,
          onChanged: _onSearchChanged,
          decoration: InputDecoration(
              border: InputBorder.none, hintText: 'Search Location'),
        ),
      ),
      body: ListView(
        children: getChildren(),
      ),
    );
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        setState(() {
          predictions = [];
        });
        return;
      }
      setState(() {
        isLoading = true;
      });
      final response = await AllApis().getAutoCompleteLocation(
          input: query, lat: widget.lat, long: widget.long, radius: radius);
      setState(() {
        isLoading = false;
      });
      if (response != null) {
        setState(() {
          predictions = jsonDecode(response.body)['predictions'];
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  getChildren() {
    final width = MediaQuery.of(context).size.width;
    List<Widget> children = [];
    children.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(Icons.my_location_rounded, color: Colors.blue),
          title: Text('Current Location'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: (){
            AllData.addressData = null;
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (route) => false);
          },
        ),
      ),
    );
    predictions.forEach((e) {
      children.add(GestureDetector(
        onTap: () {
          onItemSelect(e);
        },
        child: Row(
          children: [
            Container(
              width: 70,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    child: Icon(
                      Icons.location_on,
                      color: Color(0xAA000000),
                      size: 16,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0x30CBC3E3)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      e['distance_meters'] != null
                          ? e['distance_meters'] < 1000
                              ? '${e['distance_meters']} m'
                              : e['distance_meters'] / 1000 < 10
                                  ? (e['distance_meters'] / 1000)
                                          .toStringAsFixed(1) +
                                      ' km'
                                  : (e['distance_meters'] / 1000)
                                          .toStringAsFixed(0) +
                                      ' km'
                          : 'NA',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.red[800],
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: width - 70,
              height: 60,
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: e['structured_formatting']['main_text'] + '\n',
                    style: TextStyle(
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    children: [
                      TextSpan(
                        text: e['structured_formatting']['secondary_text'],
                        style: TextStyle(color: Colors.grey, height: 2),
                      )
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.2)),
              ),
            ),
          ],
        ),
      ));
    });
    return children;
  }

  onItemSelect(e) {
    print('in item');
    final id = e['place_id'];
    setState(() {
      isLoading = true;
    });
    AllApis().getLocationById(id: id).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == null) return;
      final result = jsonDecode(value.body)['result'];
      final location = result['geometry']['location'];
      print("location = $location");
      Navigator.pop(context, location);
    });
  }

  @override
  void initState() {
    super.initState();
    AllApis.staticContext = context;
    AllApis.staticPage = ChangeLocation(
      long: widget.long,
      lat: widget.lat,
    );
  }
}
