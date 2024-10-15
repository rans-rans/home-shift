import "dart:io";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:home_shift/domain/entities/image_data.dart";
import "package:home_shift/domain/use_cases/download_image_use_case.dart";
import "package:home_shift/domain/use_cases/get_image_bytes_use_case.dart";
import "package:home_shift/domain/use_cases/get_image_use_case.dart";
import "package:home_shift/utils/constants/string_constants.dart";

const methodChanel = MethodChannel("rans_innovations/home_shift");

class WallpaperProvider with ChangeNotifier {
  final GetImageDataUseCase getImageDataUseCase;
  final DownloadImageUseCase downloadImageUseCase;
  final GetImageBytesUseCase getImageBytesUseCase;

  WallpaperProvider({
    required this.getImageDataUseCase,
    required this.getImageBytesUseCase,
    required this.downloadImageUseCase,
  });

  ImageData _imageData = ImageData(
    imageUrl: "",
    imageDescription: "",
    subDescription: "",
    imageFile: File(""),
  );

  ImageData get imageData => _imageData;

  Future<ImageData> getWallpaperData({bool shouldNotify = true}) async {
    try {
      _imageData = await getImageDataUseCase.execute();
      _imageData.imageFile = await downloadImageUseCase.execute(
        imageUrl: _imageData.imageUrl,
        filename: _imageData.subDescription,
      );
      if (shouldNotify) notifyListeners();
      return _imageData;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> downloadImage() async {
    try {
      if (_imageData.imageFile == null) await getWallpaperData();

      final sourceImage = _imageData.imageFile!;

      const downloadsFolder = "/storage/emulated/0/Download/";
      final imgPath = "$downloadsFolder${_imageData.subDescription}.jpg";

      sourceImage.copy(imgPath).then((_) {
        methodChanel.invokeMethod(showToastKey, "Image downloaded to downloads folder");
      });
    } catch (e) {
      methodChanel.invokeMethod(showToastKey, "Image download failed");
    }
  }

  //TODO continue to  check if  scheduling  works
  Future<void> scheduleWallpaper(TimeOfDay timeOfDay) async {
    methodChanel.invokeMethod(scheduleWallpaperKey, {
      "hour": timeOfDay.hour,
      "minute": timeOfDay.minute,
    });
  }

  void manuallySetWallpaper() async {
    methodChanel.invokeMethod(setWallpaperKey, _imageData.imageFile!.path);
    methodChanel.invokeMethod(showToastKey, "Wallpaper set successfully");
  }

  Future<void> cancelWallpaperSchedule() async {
    await methodChanel.invokeMethod(cancelScheduleKey);
  }
}
