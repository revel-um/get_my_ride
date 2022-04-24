import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatefulWidget {
  final onTap;
  final itemCount;
  final initialRating;

  const RatingWidget({this.onTap, this.itemCount = 5, this.initialRating = 0.0});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  bool ignoreGestures = false;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: double.parse(widget.initialRating.toString()),
      minRating: 0,
      itemSize: 20,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: widget.itemCount,
      ignoreGestures: ignoreGestures,
      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.black,
      ),
      onRatingUpdate: (rating) {
        widget.onTap(rating);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.onTap == null) ignoreGestures = true;
  }
}
