import "dart:typed_data";

import "package:flutter/material.dart";
import "package:home_shift/presentation/provider/settings_provider.dart";
import "package:home_shift/presentation/provider/wallpaper_provider.dart";
import "package:home_shift/presentation/widgets/home_screen_widgets/background_image_widget.dart";
import "package:home_shift/presentation/widgets/home_screen_widgets/control_panel_widget.dart";
import "package:home_shift/presentation/widgets/home_screen_widgets/expandable_card.dart";
import "package:home_shift/presentation/widgets/home_screen_widgets/loading_shimmer.dart";

import "package:provider/provider.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WallpaperProvider wallpaperProvider;
  late SettingsProvider settingsProvider;

  bool imageLoading = false;
  bool imageDownloading = false;

  // this holds the image bytes
  Uint8List imageBytes = Uint8List(0);

  Future<void> loadImage() async {
    try {
      setState(() => imageLoading = true);
      await wallpaperProvider.getWallpaperData().then((wallpaperData) async {
        imageBytes = await wallpaperData.imageFile!.readAsBytes();
      });
    } finally {
      setState(() => imageLoading = false);
    }
  }

  Future<void> downloadImage() async {
    setState(() => imageDownloading = true);
    wallpaperProvider.downloadImage().whenComplete(() {
      setState(() => imageDownloading = false);
    });
  }

  @override
  void initState() {
    super.initState();
    wallpaperProvider = Provider.of<WallpaperProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.loadSettings();
    loadImage();
    methodChanel.invokeMethod("initialize_permissions");
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: switch (imageLoading) {
        true => const LoadingShimmer(),
        false => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              BackgroundImage(imageBytes: imageBytes),
              ExpandableCard(
                width: width,
                imageData: wallpaperProvider.imageData,
              ),
              ControlPanelWidget(
                loadImage: loadImage,
                downloadImage: downloadImage,
                imageDownloading: imageDownloading,
              )
            ],
          ),
      },
    );
  }
}
