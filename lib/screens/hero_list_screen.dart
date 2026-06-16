import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/opendota_service.dart';
import '../repositories/hero_repository.dart';
import '../services/hive_service.dart';
import 'hero_detail_screen.dart';

class HeroListScreen extends StatefulWidget {
  const HeroListScreen({super.key});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  final OpenDotaService service = OpenDotaService();

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

          return ListView.builder(
            itemCount: heroes.length,
            itemBuilder: (context, index) {
              final hero = heroes[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(hero.id.toString()),
                ),
                title: Text(hero.localizedName),
                subtitle: Text(hero.attackType),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          HeroDetailScreen(hero: hero),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}