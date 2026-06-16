import 'package:flutter/material.dart';

import '../models/hero_model.dart';
import '../services/opendota_service.dart';
import 'hero_detail_screen.dart';

class HeroListScreen extends StatefulWidget {
  const HeroListScreen({super.key});

  @override
  State<HeroListScreen> createState() => _HeroListScreenState();
}

class _HeroListScreenState extends State<HeroListScreen> {
  final OpenDotaService service = OpenDotaService();

  late Future<List<HeroModel>> heroesFuture;

  @override
  void initState() {
    super.initState();
    heroesFuture = service.getHeroes();
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
              child: Text(
                "Błąd:\n${snapshot.error}",
                textAlign: TextAlign.center,
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