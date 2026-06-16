import 'package:http/http.dart' as http;

class OpenDotaService {
  static const String baseUrl =
      "https://api.opendota.com/api";

  Future<String> getHeroesRaw() async {
    final response = await http.get(
      Uri.parse("$baseUrl/heroStats"),
    );

    if (response.statusCode == 200) {
      return response.body;
    }

    throw Exception("API error");
  }
}