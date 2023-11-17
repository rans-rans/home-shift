import 'dart:io';

class ImageData {
  final String imageUrl;
  final String subDescription;
  final String imageDescription;
  File? imageFile;

  ImageData({
    required this.imageUrl,
    required this.imageFile,
    required this.imageDescription,
    required this.subDescription,
  });

  factory ImageData.fromJson(Map<String, String> json) {
    return ImageData(
      imageUrl: json["imageUrl"]!,
      imageFile: null,
      subDescription: json["subDescription"]!,
      imageDescription: json["imageDescription"]!,
    );
  }
}
