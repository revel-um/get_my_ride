import 'dart:io';

import 'package:flutter/material.dart';

class NetworkAndFileImage extends StatelessWidget {
  final imageData;
  final fit;
  final height;
  final borderRadius;

  const NetworkAndFileImage(
      {this.imageData, this.fit, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    if (imageData.toString().startsWith('http')) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          imageData,
          width: double.infinity,
          height: double.parse(height.toString()),
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          fit: fit,
        ),
      );
      // } catch (e) {
      //   return Icon(Icons.image_not_supported, color: MyColors.primaryColor);
      // }
    } else {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(imageData),
          width: double.infinity,
          height: double.parse(height.toString()),
          fit: fit,
        ),
      );
    }
  }
}
