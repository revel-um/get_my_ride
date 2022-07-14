import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/screens/offlinePage.dart';
import 'package:quick_bite/screens/verification/checkNumber.dart';

class AllApis {
  static const String base_url =
      'http://ec2-13-235-33-251.ap-south-1.compute.amazonaws.com:3000';
  static const String google_map_key =
      'AIzaSyDCT9KsaHIRSpUMkhjNPdyxPkhafbWAm_s';

  static var staticContext;
  static var staticPage;

  void navigate() {
    Navigator.pushReplacement(
      staticContext,
      MaterialPageRoute(
        builder: (context) => OfflinePage(comingFrom: staticPage),
      ),
    );
  }

  void authenticate() {
    Navigator.pushAndRemoveUntil(
      staticContext,
      MaterialPageRoute(builder: (context) => CheckNumber()),
      (route) => false,
    );
  }

  Future<dynamic> sentOtp({phoneNumber}) async {
    try {
      Uri uri =
          Uri.parse('$base_url/verification/sendOtp?phoneNumber=$phoneNumber');
      final header = {
        'Content-Type': 'application/json',
      };
      http.Response response = await http.get(uri, headers: header);
      if (response.statusCode == 500) {
        navigate();
        return null;
      }
      return response;
    } catch (e) {
      navigate();
      return null;
    }
  }

  Future<dynamic> verifyOtp({phoneNumber, otp}) async {
    try {
      Uri uri = Uri.parse('$base_url/verification/verifyOtp');
      final header = {
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        "phoneNumber": phoneNumber,
        "otp": otp,
      });
      http.Response response =
          await http.post(uri, headers: header, body: body);
      if (response.statusCode == 500) {
        navigate();
        return null;
      }
      return response;
    } catch (e) {
      navigate();
      return null;
    }
  }

  Future<dynamic> getProductsInRange(
      {@required token,
      @required km,
      @required lat,
      @required lon,
      city,
      searchPurelyOnLocation = false,
      searchByCityOnly = false}) async {
    print('inside get product in range token = $token');
    try {
      if (searchByCityOnly) {
        km = null;
      }
      Uri uri = Uri.parse(
          '$base_url/products/getAllProducts?km=$km&latitude=$lat&longitude=$lon&city=$city&searchPurelyOnLocation=$searchPurelyOnLocation');
      print(
          '$base_url/products/getAllProducts?km=$km&latitude=$lat&longitude=$lon&city=$city&searchPurelyOnLocation=$searchPurelyOnLocation');
      http.Response response = await http.get(
        uri,
        headers: {
          'Authorization': token.toString(),
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 401) {
        authenticate();
        return null;
      }
      if (response.statusCode == 500) {
        navigate();
        return null;
      }
      return response;
    } catch (e) {
      navigate();
      return null;
    }
  }

  Future<dynamic> getMyOrders({@required token}) async {
    print('inside get product in range token = $token');
    try {
      Uri uri = Uri.parse('$base_url/orders/getMyOrders');
      http.Response response = await http.get(
        uri,
        headers: {
          'Authorization': token.toString(),
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 401) {
        authenticate();
        return null;
      }
      if (response.statusCode == 500) {
        navigate();
        return null;
      }
      return response;
    } catch (e) {
      navigate();
      return null;
    }
  }

  Future<dynamic> getAutoCompleteLocation(
      {@required input, lat, long, radius}) async {
    http.Response response;
    try {
      Uri uri = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input${radius != null && radius > 0 ? '&radius=$radius' : ''}&country%3AIN%7C&key=$google_map_key${lat != null && long != null ? '&origin=$lat, $long&location=$lat, $long' : ''}');
      response = await http.get(uri);
      if (response.statusCode == 200)
        return response;
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> updateUser(
      {@required token,
      profilePicture,
      firstName,
      middleName,
      lastName,
      age,
      gender,
      latitude,
      longitude,
      address,
      phoneNumber}) async {
    try {
      Map<String, String> fields = {
        if (firstName != null) 'firstName': firstName,
        if (middleName != null) 'middleName': middleName,
        if (lastName != null) 'lastName': lastName,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (address != null) 'address': address,
        if (phoneNumber != null )
          'phoneNumber': phoneNumber,
      };
      AllData.userModel.setUserModelFromJsonBody(fields);
      var request = http.MultipartRequest(
          'PATCH', Uri.parse('$base_url/users/updateUser'));
      request.headers.addAll({
        'Authorization': token.toString(),
        'Content-Type': 'application/json',
      });
      request.fields.addAll(fields);
      if (profilePicture != null &&
          profilePicture != '' &&
          profilePicture != 'null')
        request.files.add(await http.MultipartFile.fromPath(
            'profilePicture', profilePicture));

      print(token);
      http.StreamedResponse responseStream = await request.send();

      http.Response response = await http.Response.fromStream(responseStream);
      print(response.body);
      print(response.statusCode);
      print(response.reasonPhrase);
      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        authenticate();
        return null;
      } else {
        navigate();
        return null;
      }
    } catch (e) {
      print(e);
      navigate();
      return null;
    }
  }

  Future<dynamic> getLocationById({@required id}) async {
    http.Response response;
    try {
      Uri uri = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=$google_map_key');
      response = await http.get(uri);
      if (response.statusCode == 200)
        return response;
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> changeProductState(
      {@required token,
      @required productId,
      @required state,
      @required storeId}) async {
    try {
      Uri uri = Uri.parse('$base_url/orders/addOrUpdateOrderState');
      final header = {
        'Authorization': token.toString(),
        'Content-Type': 'application/json',
      };
      final body = json
          .encode({"productId": productId, "state": state, "store": storeId});
      http.Response response =
          await http.post(uri, headers: header, body: body);
      if (response.statusCode == 500) {
        navigate();
        return null;
      }
      if (response.statusCode == 401) {
        authenticate();
        return null;
      }
      return response;
    } catch (e) {
      navigate();
      return null;
    }
  }
}
