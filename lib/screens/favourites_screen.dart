import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/hive_service.dart';

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
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final raw = await hive.getHeroes();
    final favIds = await hive.getFavorites();

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
          );
        },
      ),
    );
  }
}