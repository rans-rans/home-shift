import 'dart:convert';

import 'package:flutter/material.dart';

class Settings {
  bool autoChangeWallpaper;
  bool batteryOptimized;
  TimeOfDay wallpaperChangeTime;
  Settings({
    this.batteryOptimized = false,
    this.autoChangeWallpaper = false,
    this.wallpaperChangeTime = const TimeOfDay(
      hour: 8,
      minute: 30,
    ),
  });

  factory Settings.fromJson(String? settingsJson) {
    if (settingsJson == null) return Settings();
    final settingsData = json.decode(settingsJson) as Map<String, dynamic>;
    return Settings(
      autoChangeWallpaper: settingsData["automaticallyChangeWallpaper"] ?? false,
      batteryOptimized: settingsData["battery_optimized"] ?? false,
      wallpaperChangeTime: TimeOfDay(
        hour: settingsData["wallpaper_change_hour"] ?? 8,
        minute: settingsData["wallpaper_change_minute"] ?? 30,
      ),
    );
  }

  Settings copyWith({
    TimeOfDay? timeOfDay,
    bool? autoChange,
    bool? optimizeBattery,
  }) {
    return Settings(
      wallpaperChangeTime: timeOfDay ?? wallpaperChangeTime,
      autoChangeWallpaper: autoChange ?? autoChangeWallpaper,
      batteryOptimized: optimizeBattery ?? batteryOptimized,
    );
  }

  String toJson() {
    return json.encode({
      "automaticallyChangeWallpaper": autoChangeWallpaper,
      "wallpaper_change_hour": wallpaperChangeTime.hour,
      "wallpaper_change_minute": wallpaperChangeTime.minute,
      "battery_optimized": batteryOptimized,
    });
  }
}
