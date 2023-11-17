import "dart:io";
import "dart:typed_data";

import "package:home_shift/domain/entities/image_data.dart";

abstract class WallpaperRepository {
  Future<ImageData> getWallpaper();
  Future<File> downloadWallpaper(
      {required String imageUrl, required String filename});
  Future<Uint8List> getWallpaperBytes({required String imageUrl});
}
