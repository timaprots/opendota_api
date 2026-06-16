import 'package:flutter/material.dart';

import 'screens/hero_list_screen.dart';

void main() {
  runApp(const DotaStatsApp());
}

class DotaStatsApp extends StatelessWidget {
  const DotaStatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dota Stats",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HeroListScreen(),
    );
  }
}