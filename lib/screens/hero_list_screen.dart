import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/opendota_service.dart';
import '../repositories/hero_repository.dart';
import '../services/hive_service.dart';
import 'hero_detail_screen.dart';
import '../services/analytics.dart';

class HeroListScreen extends StatefulWidget {
  const HeroListScreen({super.key});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  final HiveService hive = HiveService();
  late HeroRepository repository;
  late Future<List<HeroModel>> heroesFuture;

  @override
  void initState() {
    super.initState();
    repository = HeroRepository(
      api: OpenDotaService(),
      cache: HiveService(),
    );

    heroesFuture = repository.getHeroes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dota Heroes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                heroesFuture = repository.getHeroes();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<HeroModel>>(
        future: heroesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Nie udało się pobrać danych.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          heroesFuture =
                              repository.getHeroes();
                        });
                      },
                      child: const Text("Spróbuj ponownie"),
                    ),
                  ],
                ),
              ),
            );
          }

          final heroes = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              Analytics.log("heroes_refreshed");
              setState(() {
                heroesFuture = repository.getHeroes();
              });

              await heroesFuture;
            },
            child: ListView.builder(
              itemCount: heroes.length,
              itemBuilder: (context, index) {
                final hero = heroes[index];

                return FutureBuilder<bool>(
                  future: hive.isFavorite(hero.id),
                  builder: (context, snapshot) {
                    final isFav = snapshot.data ?? false;

                    return ListTile(
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

                      trailing: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : null,
                        ),
                        onPressed: () async {
                          if (isFav) {
                            await hive.removeFavorite(hero.id);
                          } else {
                            await hive.addFavorite(hero.id);
                          }

                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}