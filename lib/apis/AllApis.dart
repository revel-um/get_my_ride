import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_bite/screens/offlinePage.dart';

class AllApis {
  static const String base_url = 'https://madhuram-marketapis.herokuapp.com';
  static var staticContext;
  static var staticPage;

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

  void navigate() {
    Navigator.pushReplacement(
      staticContext,
      MaterialPageRoute(
        builder: (context) => OfflinePage(comingFrom: staticPage),
      ),
    );
  }
}
