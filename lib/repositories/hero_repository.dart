import 'dart:convert';
import '../models/hero_model.dart';
import '../services/hive_service.dart';
import '../services/opendota_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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

      if (decoded is! List) {
        throw Exception("API nie zwróciło listy");
      }

/*      return decoded
          .map((e) => HeroModel.fromJson(e))
          .toList();
    } catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: "OpenDota API / Cache error",
      );
*/

      return decoded
          .map((e) => HeroModel.fromJson(e))
          .toList();
    } catch (e) {
      print("ERROR: $e");

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

  Future<void> toggleFavorite(int heroId) async {
    final isFav = await cache.isFavorite(heroId);

    if (isFav) {
      await cache.removeFavorite(heroId);
    } else {
      await cache.addFavorite(heroId);
    }
  }

  Future<List<int>> getFavoritesIds() {
    return cache.getFavorites();
  }
}