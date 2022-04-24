import 'package:flutter/material.dart';

class ProfilePictureTextField extends StatelessWidget {
  final controller;
  final hint;
  final enabled;

  const ProfilePictureTextField({this.controller, @required this.hint, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: 5,
        child: Container(
          height: 55,
          child: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            enabled: enabled,
            style: TextStyle(fontSize: 16, fontFamily: 'ZenKurenaido'),
            decoration: InputDecoration(
              fillColor: Colors.white,
              label: Text(hint),
              labelStyle: TextStyle(fontSize: 14, fontFamily: 'ZenKurenaido'),
              filled: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder getBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Color(0xFFEEEEEE),
      ),
    );
  }
}
