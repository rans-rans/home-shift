import "dart:io";
import "dart:typed_data";

import "package:home_shift/data/data_sources/remote_data_sources/remote_data_source_repo/remote_data_source.dart";
import "package:home_shift/domain/entities/image_data.dart";
import "package:home_shift/domain/repositories/wallpaper_repository.dart";
import "package:home_shift/presentation/provider/wallpaper_provider.dart";

class WallpaperRepoImpl implements WallpaperRepository {
  final RemoteDataSource remoteDataSource;

  WallpaperRepoImpl({required this.remoteDataSource});

  @override
  Future<ImageData> getWallpaper() async {
    final rawWallpaperData = await remoteDataSource.getBingImageOfTheDay();
    final imageData = ImageData.fromJson(rawWallpaperData);
    return imageData;
  }

  @override
  Future<File> downloadWallpaper({required String imageUrl, required String filename}) async {
    try {
      final imageBytes = await remoteDataSource.getImageBytes(imageUrl: imageUrl);

      final appDocumentsDirectory =
          await methodChanel.invokeMethod("getExternalStorage") as String?;
      if (appDocumentsDirectory == null) throw Exception();
      final downloadsDirectory = Directory(appDocumentsDirectory);
      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory.createSync(recursive: true);
      }

      final file = File("$appDocumentsDirectory/$filename.jpg");
      await file.writeAsBytes(imageBytes);

      return file;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Uint8List> getWallpaperBytes({required String imageUrl}) async {
    return await remoteDataSource.getImageBytes(imageUrl: imageUrl);
  }
}
