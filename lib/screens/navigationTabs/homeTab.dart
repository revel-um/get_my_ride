import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_bite/components/productCard.dart';
import 'package:quick_bite/components/shimmerWidget.dart';
import 'package:quick_bite/dialogBoxes/titleAndSubtitleWithOkayActionDialog.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/globalsAndConstants/networkChecker.dart';

class HomeTab extends StatefulWidget {
  final changeTab;
  final changeLoadingStatus;

  const HomeTab({@required this.changeTab, @required this.changeLoadingStatus});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    // profileImage = CircleAvatar(
    //   backgroundImage: NetworkImage(imageLink),
    //   onBackgroundImageError: (obj, error) {
    //     print('obj = $obj');
    //     print('error = $error');
    //     setState(() {
    //       profileImage = Icon(Icons.person);
    //     });
    //   },
    // );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    if (AllData.addressData == null) {
      AllData.repo = '';
      checkPermissions();
    } else {
      address = '${AllData.addressData.name}';
      lat = AllData.lat;
      lon = AllData.lon;
    }
  }

  bool isLoading = false, networkError = false, locationError = false;
  double lat = 0.0, lon = 0.0;
  String address = 'Looking for your location';
  String imageLink = 'https://wallpaperaccess.com/full/2213424.jpg';
  dynamic profileImage = Icon(Icons.person);
  Map<String, bool> vehicleTypes = {
    'CAR': true,
    'BIKE': true,
    'SCOOTER': true,
    'BICYCLE': true,
  };

  @override
  Widget build(BuildContext context) {
    return getBody(
      locationError: locationError,
      networkError: networkError,
    );
  }

  onStatusReceived(PermissionStatus status) async {
    setState(() {
      isLoading = true;
      if (widget.changeLoadingStatus != null) {
        widget.changeLoadingStatus(isLoading);
      }
    });
    if (await NetworkCheckingClass().hasNetwork() == false) {
      setState(() {
        networkError = true;
        locationError = false;
        isLoading = false;
        if (widget.changeLoadingStatus != null) {
          widget.changeLoadingStatus(isLoading);
        }
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
          onNo: () {
            setState(() {});
          },
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
            onNo: () {
              setState(() {});
            },
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
        desiredAccuracy: LocationAccuracy.best,
      );
      lat = position.latitude;
      lon = position.longitude;
      try {
        final addresses = await placemarkFromCoordinates(lat, lon);
        setState(() {
          AllData.addressData = addresses[0];
          AllData.lat = lat;
          AllData.lon = lon;
          address = '${addresses[0].name}';
          isLoading = false;
          if (widget.changeLoadingStatus != null) {
            widget.changeLoadingStatus(isLoading);
          }
          networkError = false;
          locationError = false;
        });
      } catch (e) {}
    }
    setState(() {
      isLoading = false;
      if (widget.changeLoadingStatus != null) {
        widget.changeLoadingStatus(isLoading);
      }
    });
  }

  void checkPermissions() {
    Permission.locationWhenInUse.status.then(
      (value) => {onStatusReceived(value)},
    );
  }

  getBody({locationError = false, networkError = false}) {
    if (locationError || networkError) {
      return RefreshIndicator(
          child: ListView(
            children: [
              SvgPicture.asset(
                networkError
                    ? 'assets/svgs/no_internet.svg'
                    : 'assets/svgs/no_location.svg',
              ),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: networkError
                        ? 'We could not detect a network connection.\nPlease provide internet and '
                        : 'We could not find your location.\nPlease enable gps and ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'pull down to refresh.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: MyColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onRefresh: () async {
            checkPermissions();
          });
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Search',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
          titleSpacing: 8.0,
          title: Text(
            'SCOOBY',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              snap: true,
              toolbarHeight: 0.0,
              titleSpacing: 8.0,
              backgroundColor: Colors.white,
              floating: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(140),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Current Location',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: -10.0,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.location_on,
                          color: MyColors.primaryColor,
                          size: 30,
                        ),
                        title: ShimmerWidget(
                          isLoading: isLoading,
                          child: Text(
                            address.replaceAll(',', ', '),
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: getVehicleChips(),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.filter_alt_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: 2,
              children: getChildren(),
              childAspectRatio: 8.0 / 9.0,
            ),
          ],
        ),
      );
    }
  }

  List<Widget> getChildren() {
    List<Widget> items = [];
    ['BMW', 'i10', 'i20', 'MW20', 'AZ-alpha'].forEach((element) {
      Widget item = ProductCard(model: element, imageLink: imageLink,);
      items.add(item);
      items.add(item);
      items.add(item);
    });
    return items;
  }

  Wrap getVehicleChips() {
    List<Widget> chips = [];
    vehicleTypes.forEach((key, value) {
      chips.add(Padding(
        padding: const EdgeInsets.only(right: 2.0),
        child: ChoiceChip(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          label: Text(
            key,
            style: TextStyle(
              color: value ? Colors.white : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          selectedColor: MyColors.primaryColor,
          selected: value,
          onSelected: (bool selected) {
            setState(() {
              vehicleTypes[key] = !value;
              //TODO: Work on getVehicleList
              // getVehicleList('');
            });
          },
        ),
      ));
    });
    return Wrap(children: chips);
  }
}
