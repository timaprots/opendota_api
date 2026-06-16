import 'dart:convert';

import '../models/hero_model.dart';
import '../services/hive_service.dart';
import '../services/opendota_service.dart';

class HeroRepository {
  final OpenDotaService api;
  final HiveService cache;

  HeroRepository({
    required this.api,
    required this.cache,
  });

  Future<List<HeroModel>> getHeroes() async {
    try {
      final rawData = await api.getHeroesRaw();

      await cache.saveHeroes(rawData);

      final List decoded = jsonDecode(rawData);

      return decoded
          .map((e) => HeroModel.fromJson(e))
          .toList();
    } catch (_) {
      final cached = await cache.getHeroes();

      if (cached != null) {
        final List decoded = jsonDecode(cached);

        return decoded
            .map((e) => HeroModel.fromJson(e))
            .toList();
      }

      rethrow;
    }
  }
}