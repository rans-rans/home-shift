import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/wallpaper_provider.dart';

class SetWallpaperButton extends StatelessWidget {
  const SetWallpaperButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<WallpaperProvider>(context, listen: false)
            .manuallySetWallpaper();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      child: const Text(
        "Set as wallpaper",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
