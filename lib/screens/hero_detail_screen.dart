import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/hive_service.dart';
import '../services/analytics.dart';

class HeroDetailScreen extends StatefulWidget {
  final HeroModel hero;

  const HeroDetailScreen({
    super.key,
    required this.hero,
  });

  @override
  State<HeroDetailScreen> createState() => _HeroDetailScreenState();
}

class _HeroDetailScreenState extends State<HeroDetailScreen> {
  final HiveService hive = HiveService();

  @override
  void initState() {
    super.initState();
    Analytics.log("hero_opened");
  }

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
          title: Text(widget.hero.localizedName),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.hero.imageUrl,
                    height: 180,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
                  ),
                  Text(
                    widget.hero.localizedName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Primary Attribute: ${getAttribute(widget.hero.primaryAttr)}",
                  ),
                  const SizedBox(height: 10),
                  Text("Attack Type: ${widget.hero.attackType}"),
                  const SizedBox(height: 10),
                  Text("Professional Picks: ${widget.hero.proPick}"),
                  const SizedBox(height: 10),
                  Text("Professional Wins: ${widget.hero.proWins}"),
                  const SizedBox(height: 10),
                  Text(
                    "Win Rate: ${widget.hero.winRate.toStringAsFixed(2)}%",
                  ),
                ],
              ),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final isFav = await hive.isFavorite(widget.hero.id);

          if (isFav) {
            await hive.removeFavorite(widget.hero.id);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Usunięto z ulubionych"),
              ),
            );
          } else {
            await hive.addFavorite(widget.hero.id);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Dodano do ulubionych"),
              ),
            );
          }
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}