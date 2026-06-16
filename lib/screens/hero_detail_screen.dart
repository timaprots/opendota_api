import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/hive_service.dart';

class HeroDetailScreen extends StatelessWidget {
  final HeroModel hero;
  final HiveService hive = HiveService();

  HeroDetailScreen({
    super.key,
    required this.hero,
  });

  String getAttribute(String attr) {
    switch (attr) {
      case "str":
        return "Strength";
      case "agi":
        return "Agility";
      case "int":
        return "Intelligence";
      default:
        return attr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hero.localizedName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  hero.localizedName,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Primary Attribute: ${getAttribute(hero.primaryAttr)}",
                ),
                const SizedBox(height: 10),
                Text(
                  "Attack Type: ${hero.attackType}",
                ),
                const SizedBox(height: 10),
                Text(
                  "Professional Picks: ${hero.proPick}",
                ),
                const SizedBox(height: 10),
                Text(
                  "Professional Wins: ${hero.proWins}",
                ),
                const SizedBox(height: 10),
                Text(
                  "Win Rate: ${hero.winRate.toStringAsFixed(2)}%",
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await hive.addFavorite(hero.id);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Dodano do ulubionych"),
            ),
          );
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}