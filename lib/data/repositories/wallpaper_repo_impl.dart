import "dart:io";
import "dart:typed_data";

import "package:home_shift/data/data_sources/remote_data_sources/remote_data_source_repo/remote_data_source.dart";
import "package:home_shift/domain/entities/image_data.dart";
import "package:home_shift/domain/repositories/wallpaper_repository.dart";
import "package:path_provider/path_provider.dart";

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
  Future<File> downloadWallpaper(
      {required String imageUrl, required String filename}) async {
    final imageBytes = await remoteDataSource.getImageBytes(imageUrl: imageUrl);

    final appDocumentsDirectory = await getExternalStorageDirectory();
    final downloadsDirectoryPath = appDocumentsDirectory!.path;

    final downloadsDirectory = Directory(downloadsDirectoryPath);
    if (!downloadsDirectory.existsSync()) {
      downloadsDirectory.createSync(recursive: true);
    }

    final file = File("$downloadsDirectoryPath/$filename.jpg");
    await file.writeAsBytes(imageBytes);

    return file;
  }

  @override
  Future<Uint8List> getWallpaperBytes({required String imageUrl}) async {
    return await remoteDataSource.getImageBytes(imageUrl: imageUrl);
  }
}
