import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/hero_list_screen.dart';
import 'screens/favourites_screen.dart';
import 'widgets/bottom_nav.dart';
import 'screens/stats_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;
  
  runApp(const DotaStatsApp());
}

class DotaStatsApp extends StatelessWidget {
  const DotaStatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int index = 0;

  final pages = const [
    HeroListScreen(),
    FavoritesScreen(),
    StatsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNav(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
      ),
    );
  }
}