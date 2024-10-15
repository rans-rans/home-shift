import "dart:ui";

import "package:flutter/material.dart";
import "package:home_shift/domain/entities/image_data.dart";

import "set_wallpaper_button.dart";

class ExpandableCard extends StatefulWidget {
  final double width;
  final ImageData imageData;

  const ExpandableCard({
    required this.width,
    required this.imageData,
    super.key,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> heightAnimation;
  late Animation<double> widthAnimation;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() => setState(() => {}));

    widthAnimation = Tween<double>(
      begin: 50,
      end: widget.width,
    ).animate(animationController);
    heightAnimation = Tween<double>(
      begin: 50,
      end: 300,
    ).animate(animationController);

    opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 1,
    ).animate(animationController);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: GestureDetector(
        onTap: switch (widget.imageData.imageFile == null) {
          true => null,
          false => () {
              setState(() {
                if (animationController.isCompleted) {
                  animationController.reverse();
                } else {
                  animationController.forward();
                }
              });
            }
        },
        child: Container(
          width: widthAnimation.value,
          alignment: Alignment.center,
          height: heightAnimation.value,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox.expand(),
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child: switch (animationController.isCompleted) {
                  false => const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                  true => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.imageData.imageDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.imageData.subDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SetWallpaperButton()
                      ],
                    ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
