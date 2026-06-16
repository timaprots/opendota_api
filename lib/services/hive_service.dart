import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String heroesBox = "heroes";

  Future<void> saveHeroes(String data) async {
    final box = await Hive.openBox(heroesBox);
    await box.put("heroes_data", data);
  }

  Future<String?> getHeroes() async {
    final box = await Hive.openBox(heroesBox);
    return box.get("heroes_data");
  }
}