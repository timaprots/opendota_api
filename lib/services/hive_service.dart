import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String heroesBox = "heroes";
  static const String favoritesBox = "favorites";

  Future<void> saveHeroes(String data) async {
    final box = await Hive.openBox(heroesBox);
    await box.put("heroes_data", data);
  }

  Future<String?> getHeroes() async {
    final box = await Hive.openBox(heroesBox);
    return box.get("heroes_data");
  }

  Future<void> addFavorite(int heroId) async {
    final box = await Hive.openBox(favoritesBox);
    await box.put(heroId, heroId);
  }

  Future<void> removeFavorite(int heroId) async {
    final box = await Hive.openBox(favoritesBox);
    await box.delete(heroId);
  }

  Future<List<int>> getFavorites() async {
    final box = await Hive.openBox(favoritesBox);
    return box.values.cast<int>().toList();
  }

  Future<bool> isFavorite(int heroId) async {
    final box = await Hive.openBox(favoritesBox);
    return box.containsKey(heroId);
  }
}