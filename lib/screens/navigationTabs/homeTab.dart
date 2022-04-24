import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quick_bite/apis/AllApis.dart';
import 'package:quick_bite/components/productCard.dart';
import 'package:quick_bite/components/shimmerWidget.dart';
import 'package:quick_bite/components/showDate.dart';
import 'package:quick_bite/dialogBoxes/titleAndSubtitleWithOkayActionDialog.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/globalsAndConstants/networkChecker.dart';
import 'package:quick_bite/models/productModel.dart';
import 'package:quick_bite/screens/changeLocation.dart';
import 'package:quick_bite/screens/profilePage.dart';
import 'package:quick_bite/screens/searchVehicles.dart';
import 'package:quick_bite/screens/showProductPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeTab extends StatefulWidget {
  final changeTab;
  final changeLoadingStatus;

  const HomeTab({@required this.changeTab, @required this.changeLoadingStatus});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  double km = 5;

  bool lastItem = false;
  int startDate = 0, startMonth = 0, startYear = 0;
  int endDate = 0, endMonth = 0, endYear = 0;
  bool apiCallComplete = false;

  @override
  void initState() {
    super.initState();
    // profileImage = CircleAvatar(
    //   backgroundImage: NetworkImage(imageLink),
    //   onBackgroundImageError: (obj, error) {
    //     print('obj = $obj');
    //     print('error = $error');
    //     if(mounted) setState(() {
    //       profileImage = Icon(Icons.person);
    //     });
    //   },
    // );
    final date = DateTime.now();
    startDate = date.day;
    startMonth = date.month;
    startYear = date.year;
    final tom = DateTime(startYear, startMonth, startDate + 1);
    endDate = tom.day;
    endMonth = tom.month;
    endYear = tom.year;
    if (AllData.addressData == null) {
      AllData.productModelList = [];
      checkPermissions();
    } else {
      address = '${AllData.addressData.name}';
      lat = AllData.lat;
      long = AllData.lon;
      print('inside');
      if (AllData.reload == true) {
        AllData.productModelList = [];
        AllData.reload = false;
        callApiAndGetData();
      }
    }
  }

  bool isLoading = false, networkError = false, locationError = false;
  double lat = 0.0, long = 0.0;
  String address = 'Looking for your location';
  dynamic profileImage = Icon(Icons.person);
  static const IconData slider_horizontal_3 = IconData(0xf7dc,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);

  Map<String, bool> vehicleTypes = {
    'CAR': true,
    'BIKE': true,
    'SCOOTER': true,
    'BICYCLE': true,
  };

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: getBody(
        locationError: locationError,
        networkError: networkError,
      ),
    );
  }

  onStatusReceived(PermissionStatus status) async {
    if (mounted)
      setState(() {
        isLoading = true;
        if (widget.changeLoadingStatus != null) {
          widget.changeLoadingStatus(isLoading);
        }
      });
    if (await NetworkCheckingClass().hasNetwork() == false) {
      if (mounted)
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
            if (mounted) setState(() {});
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
      if (mounted)
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
              if (mounted) setState(() {});
            },
            onYes: () async {
              await Geolocator.openLocationSettings();
            },
            title: 'Your gps is disabled.',
            subtitle: 'Press on okay and let us take you to location settings',
          ),
        );
      }
      if (mounted)
        setState(() {
          locationError = true;
          networkError = false;
        });
    } else {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      lat = position.latitude;
      long = position.longitude;
      onLocationReceived(lat, long);
    }
    if (mounted)
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
          child: Stack(
            children: [
              ListView(
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
              Center(child: isLoading == true ? SpinKit.spinner : null)
            ],
          ),
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            checkPermissions();
          });
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchVehicles(),
                    ),
                  );
                },
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
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
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
          slivers: [
            SliverAppBar(
              snap: true,
              toolbarHeight: 0.0,
              titleSpacing: 8.0,
              forceElevated: true,
              backgroundColor: Colors.white,
              floating: true,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(170),
                child: Container(
                  height: 170,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(
                        isLoading: isLoading,
                        child: GestureDetector(
                          onTap: isLoading
                              ? null
                              : () async {
                                  final location = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChangeLocation(
                                        lat: lat,
                                        long: long,
                                      ),
                                    ),
                                  );
                                  if (location == null) return;
                                  lat = location['lat'];
                                  long = location['lng'];
                                  print(lat);
                                  print(long);
                                  onLocationReceived(lat, long);
                                  setState(() {});
                                },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 40,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: 'Current Location\n',
                                      children: [
                                        TextSpan(
                                          text: address.replaceAll(',', ', '),
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ShowDate(
                              title: 'FROM',
                              date: startDate.toString().padLeft(2, '0'),
                              month: startMonth.toString().padLeft(2, '0'),
                              year: startYear.toString().padLeft(2, '0'),
                              onPressed: showDateRangePicker,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: ShowDate(
                              title: 'TO',
                              date: endDate.toString().padLeft(2, '0'),
                              month: endMonth.toString().padLeft(2, '0'),
                              year: endYear.toString().padLeft(4, '0'),
                              onPressed: showDateRangePicker,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: getVehicleChips(),
                          ),
                          PopupMenuButton(
                            onSelected: (_) {},
                            icon: Icon(slider_horizontal_3),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text('A'),
                                value: 0,
                              ),
                              PopupMenuItem(
                                child: Text('B'),
                                value: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverGrid.count(
              crossAxisCount: AllData.productModelList.isEmpty ? 1 : 2,
              children: getChildren(),
              childAspectRatio: 8.0 / 10.0,
            ),
          ],
        ),
      );
    }
  }

  List<Widget> getChildren() {
    List<Widget> items = [];
    if (AllData.productModelList.isEmpty && apiCallComplete == false)
      return [SpinKit.spinner];
    if (AllData.productModelList.isEmpty && apiCallComplete == true)
      return [Center(child: Text('We haven\'t reached to you yet'))];
    AllData.productModelList.forEach((element) {
      if (vehicleTypes[element.criteria.toUpperCase()] == false) return;
      Widget item = ProductCard(
        model: element.model,
        imageLink:
            element.productImages.length == 0 ? null : element.productImages[0],
        storeName: element.storeName,
        rentPerDay: element.rentPerDay,
        rentPerHour: element.rentPerHour,
        onSelect: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowProductPage(
                productModel: element,
              ),
            ),
          );
        },
      );
      items.add(item);
    });
    return items;
  }

  Wrap getVehicleChips() {
    List<Widget> chips = [];
    int count = 0;
    vehicleTypes.forEach((key, value) {
      if (value == true) {
        count++;
      }
    });
    if (count == 1) {
      lastItem = true;
    } else {
      lastItem = false;
    }
    vehicleTypes.forEach((key, value) {
      chips.add(ChoiceChip(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        label: Text(
          key.characters.first + key.toLowerCase().substring(1),
          style: TextStyle(
            fontSize: 12.0,
            color: value ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        selectedColor: MyColors.primaryColor,
        selected: value,
        onSelected: (value == true && lastItem == true) || isLoading
            ? null
            : (selected) {
                if (mounted)
                  setState(() {
                    vehicleTypes[key] = !value;
                  });
              },
      ));
    });
    return Wrap(children: chips, spacing: 8.0);
  }

  void onLocationReceived(double lat, double long) async {
    try {
      final addresses = await placemarkFromCoordinates(lat, long);
      if (mounted)
        setState(() {
          AllData.addressData = addresses[0];
          AllData.lat = lat;
          AllData.lon = long;
          address =
              '${AllData.addressData.name}, ${AllData.addressData.postalCode}, ${AllData.addressData.subAdministrativeArea}';
          isLoading = false;
          if (widget.changeLoadingStatus != null) {
            widget.changeLoadingStatus(isLoading);
          }
          networkError = false;
          locationError = false;
        });
      callApiAndGetData();
    } catch (e) {
      if (mounted)
        setState(() {
          locationError = true;
          networkError = false;
        });
    }
  }

  showDateRangePicker() {
    showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => DateRangePickerDialog(
        currentDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(startYear, endMonth + 3, 30),
        initialDateRange: DateTimeRange(
          start: DateTime(startYear, startMonth, startDate),
          end: DateTime(endYear, endMonth, endDate),
        ),
      ),
    ).then((value) {
      if (value == null) return;
      final start = value.start;
      final end = value.end;
      setState(() {
        startDate = start.day;
        startMonth = start.month;
        startYear = start.year;
        endDate = end.day;
        endMonth = end.month;
        endYear = end.year;
      });
    });
  }

  void callApiAndGetData() {
    SharedPreferences.getInstance().then((value) {
      final token = value.getString('token');
      if (AllData.addressData != null)
        AllApis()
            .getProductsInRange(
                token: token,
                km: km,
                lat: lat,
                lon: long,
                city: AllData.addressData.subAdministrativeArea,
                searchPurelyOnLocation: true,
                searchByCityOnly: false)
            .then(
          (value) {
            apiCallComplete = true;
            if (value == null) return;
            final body = jsonDecode(value.body);
            ProductModel().setProductModelsFromJsonBody(body);
            setState(() {});
          },
        );
    });
  }
}
