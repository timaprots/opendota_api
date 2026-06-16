import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/hero_model.dart';

class OpenDotaService {
  static const String baseUrl = "https://api.opendota.com/api";

  Future<List<HeroModel>> getHeroes() async {
    final response = await http.get(
      Uri.parse("$baseUrl/heroStats"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((hero) => HeroModel.fromJson(hero))
          .toList();
    }

    throw Exception("Nie udało się pobrać bohaterów");
  }
}