import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quick_bite/apis/AllApis.dart';
import 'package:quick_bite/globalsAndConstants/allConstants.dart';
import 'package:quick_bite/screens/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyNumber extends StatefulWidget {
  final phoneNumber;

  const VerifyNumber({this.phoneNumber});

  @override
  _VerifyNumberState createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  bool requesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'OTP',
          style: TextStyle(
            color: MyColors.primaryColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Hero(
                tag: 'verify',
                child: Icon(Icons.verified, color: MyColors.primaryColor, size: 20),
              ),
              SvgPicture.asset(
                'assets/svgs/otp.svg',
                height: MediaQuery.of(context).size.height/2,
              ),
              Text(
                'Verification Code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  wordSpacing: 1,
                ),
              ),
              Text(
                'We have sent verification code to mobile number',
                textAlign: TextAlign.center,
                style: TextStyle(height: 2, fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.phoneNumber,
                      style: TextStyle(
                        color: MyColors.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.edit,
                      color: MyColors.primaryColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 8.0),
                child: PinCodeTextField(
                  appContext: context,
                  length: 6,
                  onCompleted: (_) async {
                    setState(() {
                      requesting = true;
                    });
                    AllApis apis = AllApis();
                    final response = await apis.verifyOtp(
                        phoneNumber: widget.phoneNumber, otp: _);
                    if (response == null) return;
                    if (response.statusCode == 200) {
                      setState(() {
                        requesting = false;
                      });
                      final token = jsonDecode(response.body)['token'];
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      await pref.setString('token', token);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Wrong verification code'),
                        ),
                      );
                      setState(() {
                        requesting = false;
                      });
                    }
                  },
                  onChanged: (_) {},
                  enabled: !requesting,
                  cursorHeight: 10,
                  enablePinAutofill: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  //
                  cursorColor: MyColors.primaryColor,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.circle,
                    activeColor: MyColors.primaryColor,
                    inactiveColor: Color(0x40BA68C8),
                    selectedColor: MyColors.primaryColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    text: 'Did not received the code? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: " RESEND",
                        style: TextStyle(
                          color: MyColors.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: requesting ? SpinKit.spinner : null,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    AllApis.staticContext = context;
    AllApis.staticPage = VerifyNumber(phoneNumber: widget.phoneNumber);
  }
}
