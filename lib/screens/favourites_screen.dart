import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/hive_service.dart';
import '../services/analytics.dart';
import 'hero_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final HiveService hive = HiveService();

  List<HeroModel> favorites = [];

  @override
  void initState() {
    super.initState();
    Analytics.log("favourite_opened");
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favIds = await hive.getFavorites();
    final raw = await hive.getHeroes();

    if (raw == null) return;

    final List data = jsonDecode(raw);

    final heroes = data
        .map((e) => HeroModel.fromJson(e))
        .toList();

    setState(() {
      favorites = heroes
          .where((h) => favIds.contains(h.id))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text("Brak ulubionych"),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final hero = favorites[index];

          return ListTile(
            leading: const Icon(Icons.favorite),
            title: Text(hero.localizedName),
            subtitle: Text(hero.attackType),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HeroDetailScreen(hero: hero),
                ),
              );
            },
          );
        },
      ),
    );
  }
}