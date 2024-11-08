import 'dart:ui';

import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String image;
  const CustomImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Opacity(
        opacity: .5,
        child: Image.network(
          image,
          color: Colors.red,
        ),
      ),
      ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Image.network(
            image,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) {
                return child;
              }
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 10),
                curve: Curves.easeOut,
                child: child,
              );
            },
          ),
        ),
      )
    ]);
  }
}