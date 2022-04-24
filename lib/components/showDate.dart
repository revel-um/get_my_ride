import 'package:flutter/material.dart';

class ShowDate extends StatefulWidget {
  final date;
  final month;
  final year;
  final onPressed;
  final String title;

  const ShowDate(
      {this.date, this.onPressed, required this.title, this.month, this.year});

  @override
  _ShowDateState createState() => _ShowDateState();
}

class _ShowDateState extends State<ShowDate> {
  final numToMonth = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec'
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
          child: Container(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ],
                  ),
                  Text(
                    '${widget.date} ${numToMonth[int.parse(widget.month)]} ${widget.year}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
