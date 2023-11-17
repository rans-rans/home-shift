import "package:home_shift/domain/entities/image_data.dart";
import "package:home_shift/domain/repositories/wallpaper_repository.dart";

class GetImageDataUseCase {
  final WallpaperRepository wallpaperRepository;

  GetImageDataUseCase({required this.wallpaperRepository});

  Future<ImageData> execute() async {
    return await wallpaperRepository.getWallpaper();
  }
}
