import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/hero_list_screen.dart';

void main() async {
  runApp(const DotaStatsApp());
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

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