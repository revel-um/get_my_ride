import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quick_bite/models/orderModel.dart';

import '../models/productModel.dart';
import '../models/userModel.dart';

class MyColors {
  // static const primaryColor = Color(0xFFFDB813);
  static const primaryColor = Color(0xFF000000);
  static const Map<int, Color> colorMap = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
}

class SpinKit {
  static const spinner = SpinKitSpinningLines(color: Color(0xFF000000));
}

class AllData {
  static bool reload = false;
  static List<ProductModel> productModelList = [];
  static OrderModel orderModel = OrderModel();
  static UserModel userModel = UserModel();

  static var addressData;
  static double lat = 0.0, lon = 0.0;
}
