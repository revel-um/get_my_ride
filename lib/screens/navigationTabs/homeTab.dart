import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_bite/dialogBoxes/titleAndSubtitleWithOkayActionDialog.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/globalsAndConstants/networkChecker.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    checkPermissions();
  }

  bool isLoading = false, networkError = false, locationError = false;
  double lat = 0.0, lon = 0.0;
  String address = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.location_on,
          color: MyColors.primaryColor,
        ),
        title: Text(
          address.replaceAll(',', ', '),
          maxLines: 1,
          style: TextStyle(
            decoration: TextDecoration.underline,
            overflow: TextOverflow.ellipsis,
            color: Colors.black54,
            fontSize: 16,
            decorationStyle: TextDecorationStyle.dashed,
          ),
        ),
      ),
      body: getBody(),
    );
  }

  onStatusReceived(PermissionStatus status) async {
    setState(() {
      isLoading = true;
    });
    if (await NetworkCheckingClass().hasNetwork() == false) {
      setState(() {
        networkError = true;
        locationError = false;
      });
      return;
    }
    if (status == PermissionStatus.denied) {
      await Permission.locationWhenInUse.request().isGranted;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      showDialog(
        context: context,
        builder: (context) => TitleAndSubtitleWithOkayActionDialog(
          onYes: () async {
            await openAppSettings();
          },
          title: 'Please give us permission to access your location.',
          subtitle: 'Press on okay and let us take you to permission settings',
        ),
      );
    }
    bool permissionGranted = await Permission.location.isGranted;
    bool locationAvailable = await Geolocator.isLocationServiceEnabled();
    if (!locationAvailable) {
      setState(() {
        locationError = true;
        networkError = false;
      });
    }
    if (!permissionGranted || !locationAvailable) {
      if (permissionGranted && !locationAvailable) {
        showDialog(
          context: context,
          builder: (context) => TitleAndSubtitleWithOkayActionDialog(
            onYes: () async {
              await Geolocator.openLocationSettings();
            },
            title: 'Your gps is disabled.',
            subtitle: 'Press on okay and let us take you to location settings',
          ),
        );
      }
      setState(() {
        locationError = true;
        networkError = false;
      });
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      lat = position.latitude;
      lon = position.longitude;
      try {
        final addresses = await placemarkFromCoordinates(lat, lon);
        setState(() {
          address = '${addresses[0].name}';
          isLoading = false;
          networkError = false;
          locationError = false;
        });
      } catch (e) {}
    }
    setState(() {
      isLoading = false;
    });
    print(locationError);
    print(networkError);
  }

  void checkPermissions() {
    Permission.locationWhenInUse.status.then(
      (value) => onStatusReceived(value),
    );
  }
}

getBody({locationError = false, networkError = false}) {}
