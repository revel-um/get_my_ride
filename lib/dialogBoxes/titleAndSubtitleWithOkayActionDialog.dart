import 'package:flutter/material.dart';

class TitleAndSubtitleWithOkayActionDialog extends StatelessWidget {
  final title;
  final subtitle;
  final onYes;

  const TitleAndSubtitleWithOkayActionDialog(
      {@required this.onYes, @required this.title, @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
