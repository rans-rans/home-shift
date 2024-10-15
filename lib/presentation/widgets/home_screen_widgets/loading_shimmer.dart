import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.white,
      child: Container(
        color: Colors.grey.shade100,
      ),
    );
  }
}
