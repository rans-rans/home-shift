import 'dart:typed_data';

import 'package:home_shift/domain/repositories/wallpaper_repository.dart';

class GetImageBytesUseCase {
  final WallpaperRepository wallpaperRepository;

  GetImageBytesUseCase({required this.wallpaperRepository});

  Future<Uint8List> execute({required String imgUrl}) async {
    return await wallpaperRepository.getWallpaperBytes(imageUrl: imgUrl);
  }
}
