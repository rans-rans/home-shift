import "package:flutter/material.dart";
import "package:home_shift/presentation/screens/settings_screen.dart";

class ControlPanelWidget extends StatelessWidget {
  final VoidCallback loadImage;
  final VoidCallback downloadImage;
  final bool imageDownloading;

  const ControlPanelWidget({
    super.key,
    required this.loadImage,
    required this.downloadImage,
    required this.imageDownloading,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Positioned(
      top: height * 0.05,
      right: width * 0.01,
      child: Container(
        padding: EdgeInsets.all(height * 0.01),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            IconButton(
              tooltip: 'Reload',
              onPressed: loadImage,
              icon: const Icon(
                Icons.replay,
                color: Colors.white,
              ),
            ),
            IconButton(
              tooltip: 'Save to downloads',
              icon: Icon(
                Icons.save_alt,
                color: switch (imageDownloading) {
                  true => const Color.fromARGB(255, 74, 74, 74),
                  false => Colors.white,
                },
              ),
              onPressed: switch (imageDownloading) {
                true => null,
                false => downloadImage,
              },
            ),
            IconButton(
              tooltip: 'Settings',
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, SettingsScreen.route);
              },
            ),
          ],
        ),
      ),
    );
  }
}
