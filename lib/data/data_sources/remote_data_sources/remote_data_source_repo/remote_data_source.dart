import "dart:typed_data";

abstract class RemoteDataSource {
  Future<Map<String, String>> getBingImageOfTheDay();
  Future<Uint8List> getImageBytes({required String imageUrl});
}
