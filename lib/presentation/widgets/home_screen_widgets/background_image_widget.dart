import "dart:typed_data";

import "package:flutter/material.dart";

class BackgroundImage extends StatelessWidget {
  final Uint8List imageBytes;

  const BackgroundImage({
    required this.imageBytes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      imageBytes,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          alignment: Alignment.center,
          height: double.infinity,
          width: double.infinity,
          child: const Text(
            "Error loading image",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }
}
