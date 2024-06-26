import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/screens/homeScreen.dart';
import 'package:quick_bite/screens/verification/checkNumber.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.transparent, // status bar color
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: MaterialColor(0xFF000000, MyColors.colorMap))
            .copyWith(secondary: Colors.white),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> /*with SingleTickerProviderStateMixin*/ {
  // late AnimationController _animController;
  // late CurvedAnimation animation;
  // double animationValue = 0;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
    );
    navigate();
    // _animController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 1));
    // animation =
    //     CurvedAnimation(parent: _animController, curve: Curves.bounceOut);
    // animation.addListener(() {
    //   setState(() {
    //     animationValue = animation.value;
    //   });
    // });
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) navigate();
    // });
    // if (WidgetsBinding.instance != null)
    //   WidgetsBinding.instance!.addPostFrameCallback(
    //         (_) => _animController.forward(from: 0),
    //   );
  }

  @override
  void dispose() {
    super.dispose();
    // _animController.dispose();
  }

  void navigate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    if (token != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => CheckNumber(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: Stack(
        //   children: [
        //     Center(
        //       child: SvgPicture.asset(
        //         'assets/svgs/undraw_order_a_car_-3-tww.svg',
        //       ),
        //     ),
        //     Positioned.fill(
        //       top: (MediaQuery.of(context).size.height / 2) * animationValue,
        //       child: Center(
        //         child: Text(
        //           'GET MY RIDE',
        //           style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 20 * animationValue,
        //             fontFamily: 'FasterOne',
        //             wordSpacing: 6,
        //             letterSpacing: 3,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        );
  }
}
