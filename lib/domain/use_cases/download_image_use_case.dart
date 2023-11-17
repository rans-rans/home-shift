import "dart:io";

import "package:home_shift/domain/repositories/wallpaper_repository.dart";

class DownloadImageUseCase {
  final WallpaperRepository wallpaperRepository;

  DownloadImageUseCase({
    required this.wallpaperRepository,
  });

  Future<File> execute({
    required String imageUrl,
    required String filename,
  }) async {
    return await wallpaperRepository.downloadWallpaper(
      imageUrl: imageUrl,
      filename: filename,
    );
  }
}
