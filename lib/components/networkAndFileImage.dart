import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quick_bite/components/shimmerWidget.dart';

class NetworkAndFileImage extends StatelessWidget {
  final imageData;
  final fit;
  final height;
  final borderRadius;
  final iconColor;
  final icon;
  final width;

  const NetworkAndFileImage(
      {@required this.imageData,
      this.fit = BoxFit.cover,
      @required this.height,
      this.borderRadius,
      this.iconColor = Colors.black,
      this.icon = const Icon(Icons.image_not_supported),
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    if (imageData.toString().startsWith('http')) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(0),
        child: Image.network(
          imageData,
          errorBuilder: (context, obj, trace) {
            return Container(
              height: double.parse(height.toString()),
              child: Icon(
                icon,
                color: this.iconColor,
              ),
            );
          },
          width: double.parse(width.toString()),
          height: double.parse(height.toString()),
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return ShimmerWidget(
              isLoading: true,
              child: Container(
                color: Colors.grey,
                height: double.parse(height.toString()),
                width: double.parse(width.toString()),
              ),
            );
          },
          fit: fit,
        ),
      );
    } else {
      return imageData == null || imageData == ''
          ? Container(
              width: double.parse(width.toString()),
              height: double.parse(height.toString()),
              decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(0)),
              child: Icon(
                icon,
                color: iconColor,
              ),
            )
          : ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(0),
              child: Image.file(
                File(imageData),
                width: double.parse(width.toString()),
                height: double.parse(height.toString()),
                fit: fit,
              ),
            );
    }
  }
}
