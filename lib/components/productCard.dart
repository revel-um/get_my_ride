import 'package:flutter/material.dart';
import 'package:quick_bite/components/networkAndFileImage.dart';

class ProductCard extends StatefulWidget {
  final onSelect;
  final imageLink;
  final rentPerHour;
  final rentPerDay;
  final model;
  final storeName;

  const ProductCard(
      {this.onSelect,
      this.imageLink,
      this.rentPerHour,
      this.rentPerDay,
      this.model,
      this.storeName});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool expanded = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onSelect,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
                // border: Border.all(color: Colors.black)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                NetworkAndFileImage(
                  fit: BoxFit.cover,
                  imageData: widget.imageLink,
                  height: 130,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.model.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.storeName.toString(),
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 12.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: '\u20B9 ',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: widget.rentPerDay.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                        TextSpan(
                          text: '/Day',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
