import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowStorePage extends StatefulWidget {
  const ShowStorePage({Key? key}) : super(key: key);

  @override
  _ShowStorePageState createState() => _ShowStorePageState();
}

class _ShowStorePageState extends State<ShowStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            _launchMapsUrl();
          },
          child: Text('press'),
        ),
      ),
    );
  }

  void _launchMapsUrl({String lat = "28.7041", String long = "77.1025"}) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
