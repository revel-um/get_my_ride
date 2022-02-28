import 'package:flutter/material.dart';

class TitleAndSubtitleWithOkayActionDialog extends StatelessWidget {
  final title;
  final subtitle;
  final onYes;
  final onNo;

  const TitleAndSubtitleWithOkayActionDialog(
      {@required this.onYes, @required this.title, @required this.subtitle, @required this.onNo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onNo();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onYes();
          },
          child: Text('Okay'),
        ),
      ],
    );
  }
}
