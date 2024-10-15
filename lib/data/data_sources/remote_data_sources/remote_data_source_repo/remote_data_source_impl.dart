import "dart:typed_data";

import "package:home_shift/data/data_sources/remote_data_sources/api/api_client.dart";
import "package:home_shift/data/data_sources/remote_data_sources/remote_data_source_repo/remote_data_source.dart";
import "package:home_shift/utils/constants/string_constants.dart";
import "package:xml/xml.dart";

class RemoteDataSourceImpl implements RemoteDataSource {
  final ApiClient apiClient;

  RemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, String>> getBingImageOfTheDay() async {
    try {
      final response = await apiClient.getData(endPoint: endPointUrl);
      final xmlResponse = XmlDocument.parse(response.body);
      final imageElement = xmlResponse.findAllElements("image").first;

      final imageUrlSuffix = imageElement.getElement("url")!.innerText;
      final imageDescription = imageElement.getElement("copyright")!.innerText;
      final subDescription = imageElement.getElement("headline")!.innerText;

      final fullImageUrl = "https://www.bing.com$imageUrlSuffix";

      final imageData = {
        "imageUrl": fullImageUrl,
        "imageDescription": imageDescription,
        "subDescription": subDescription,
      };
      return imageData;
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Future<Uint8List> getImageBytes({required String imageUrl}) async {
    final imageResponse = await apiClient.getData(endPoint: imageUrl);
    final imageBytes = imageResponse.bodyBytes;
    return imageBytes;
  }
}
