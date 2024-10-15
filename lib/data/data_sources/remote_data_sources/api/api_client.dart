import "package:http/http.dart" as http;

class ApiClient {
  final http.Client httpClient;

  ApiClient({required this.httpClient});

  Future<http.Response> getData({required String endPoint}) async {
    final response = await httpClient.get(Uri.parse(endPoint));
    return response;
  }
}
