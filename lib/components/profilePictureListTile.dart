import 'package:flutter/material.dart';

class ProfilePictureListTile extends StatelessWidget {
  final icon;
  final title;
  final onPressed;

  const ProfilePictureListTile(
      {@required this.icon, @required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Material(
        elevation: 5.0,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: ListTile(
            leading: icon,
            title: title,
            onTap: onPressed,
            horizontalTitleGap: 0.0,
            trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue[300],),
          ),
        ),
      ),
    );
  }
}
