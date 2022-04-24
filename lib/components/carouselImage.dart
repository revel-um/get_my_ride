import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'networkAndFileImage.dart';

class CarouselImage extends StatefulWidget {
  final imageData;
  final fit;
  final height;
  final borderRadius;
  final iconColor;

  const CarouselImage(
      {this.imageData,
      this.fit,
      this.height,
      this.borderRadius,
      this.iconColor});

  @override
  _CarouselImageState createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.parse(widget.height.toString()),
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child: widget.imageData != null
                ? CarouselSlider(
                    carouselController: carouselController,
                    options: CarouselOptions(
                        viewportFraction: 1.0,
                        height: double.parse(widget.height.toString()),
                        enlargeCenterPage: false,
                        enableInfiniteScroll: widget.imageData.length > 1,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndex = index;
                          });
                        }),
                    items: getList(),
                  )
                : Center(
                    child: Icon(Icons.image_not_supported),
                  ),
          ),
          if (widget.imageData != null && widget.imageData.length > 1)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  color: Colors.white38,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...widget.imageData.asMap().entries.map((entry) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                .withOpacity(
                              currentIndex == entry.key ? 0.9 : 0.4,
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> items = [];
    if (widget.imageData == null) return items;
    widget.imageData.forEach((i) {
      items.add(Container(
        width: double.infinity,
        child: NetworkAndFileImage(
          imageData: i,
          fit: BoxFit.fitWidth,
          iconColor: Colors.black,
          borderRadius: BorderRadius.circular(0),
          height: double.parse(widget.height.toString()),
        ),
      ));
    });
    return items;
  }
}
