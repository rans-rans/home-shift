import 'package:flutter/material.dart';
import 'package:home_shift/presentation/provider/settings_provider.dart';
import 'package:home_shift/presentation/provider/wallpaper_provider.dart';

import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const route = "/settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<SettingsProvider>(
        child: Image.asset(
          "assets/app_icon.png",
          height: size.height * 0.2,
          fit: BoxFit.cover,
        ),
        builder: (context, settings, child) => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                child!,
                StatefulBuilder(
                  builder: (context, snap) => SwitchListTile(
                    value: settings.settings.autoChangeWallpaper,
                    onChanged: (value) async {
                      final previousSettings = settings.settings;
                      final newSettings =
                          previousSettings.copyWith(autoChange: value);
                      settings.toggleSettings(newSettings);
                      if (value == false) {
                        await Provider.of<WallpaperProvider>(context, listen: false)
                            .cancelWallpaperSchedule();
                      } else {
                        await Provider.of<WallpaperProvider>(context, listen: false)
                            .scheduleWallpaper(
                                settings.settings.wallpaperChangeTime);
                      }
                      snap(() {});
                    },
                    title: const Text("Automatic Schedule"),
                    subtitle: const Text(
                        "Do you want the home screen to automatically change everyday"),
                    isThreeLine: true,
                  ),
                ),
                StatefulBuilder(builder: (context, snap) {
                  return ListTile(
                    title: const Text("Time of reset"),
                    trailing: Text(
                      style: const TextStyle(fontWeight: FontWeight.w900),
                      settings.settings.wallpaperChangeTime.format(
                        context,
                      ),
                    ),
                    subtitle:
                        const Text("What time do you want the wallpaper to reset"),
                    onTap: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (selectedTime == null) return;
                      final previousSettings = settings.settings;
                      final newSettings =
                          previousSettings.copyWith(timeOfDay: selectedTime);
                      await settings.toggleSettings(newSettings).then((_) async {
                        if (settings.settings.autoChangeWallpaper == false) {
                          snap(() {});
                          return;
                        }
                        final homeProv =
                            Provider.of<WallpaperProvider>(context, listen: false);
                        homeProv.cancelWallpaperSchedule();
                        homeProv.scheduleWallpaper(selectedTime);
                      });
                      snap(() {});
                    },
                  );
                }),
                SizedBox(height: size.height * 0.15),
                const Text(
                  "Developed by RANS INNOVATIONS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
