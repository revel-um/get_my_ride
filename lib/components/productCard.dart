import 'package:flutter/material.dart';
import 'package:quick_bite/components/networkAndFileImage.dart';

class ProductCard extends StatelessWidget {
  final onSelect;
  final imageLink;
  final rentPerHour;
  final rentPerDay;
  final model;
  final storeName;

  ProductCard({
    this.onSelect,
    this.imageLink,
    this.rentPerHour,
    this.rentPerDay,
    this.model,
    this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkAndFileImage(
                fit: BoxFit.cover,
                imageData: imageLink,
                height: 100,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  model.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  storeName.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  model.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
