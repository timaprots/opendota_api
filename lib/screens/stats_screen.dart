import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/hive_service.dart';
import '../models/hero_model.dart';

enum StatType {
  winRate,
  proWins,
  proPicks,
}

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  StatType selectedType = StatType.winRate;
  final HiveService hive = HiveService();

  List<HeroModel> heroes = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final raw = await hive.getHeroes();

    if (raw == null) return;

    final List data = jsonDecode(raw);

    setState(() {
      heroes = data.map((e) => HeroModel.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topHeroes = heroes
        .where((h) => h.proPick > 0)
        .toList()
        ..sort((a, b) {
          switch (selectedType) {
            case StatType.winRate:
              return b.winRate.compareTo(a.winRate);

            case StatType.proWins:
              return b.proWins.compareTo(a.proWins);

            case StatType.proPicks:
              return b.proPick.compareTo(a.proPick);
          }
        });

    final top5 = topHeroes.take(5).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: heroes.isEmpty
          ? const Center(child: Text("Brak danych"))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              selectedType == StatType.winRate
                  ? "Top 5 Heroes (Win Rate)"
                  : selectedType == StatType.proWins
                  ? "Top 5 Heroes (Wins)"
                  : "Top 5 Heroes (Picks)",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text("Win Rate"),
                  selected: selectedType == StatType.winRate,
                  onSelected: (_) {
                    setState(() {
                      selectedType = StatType.winRate;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text("Wins"),
                  selected: selectedType == StatType.proWins,
                  onSelected: (_) {
                    setState(() {
                      selectedType = StatType.proWins;
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text("Picks"),
                  selected: selectedType == StatType.proPicks,
                  onSelected: (_) {
                    setState(() {
                      selectedType = StatType.proPicks;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: _getMaxY(top5),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: List.generate(
                    top5.length,
                        (i) {
                      final hero = top5[i];

                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: _getValue(hero),
                            width: 18,
                            borderRadius: BorderRadius.circular(6),
                          )
                        ],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final name = top5[value.toInt()].localizedName;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              name.length > 4 ? name.substring(0, 4) : name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getValue(HeroModel hero) {
    switch (selectedType) {
      case StatType.winRate:
        return hero.winRate;

      case StatType.proWins:
        return hero.proWins.toDouble();

      case StatType.proPicks:
        return hero.proPick.toDouble();
    }
  }
  double _getMaxY(List heroes) {
    double max = 0;

    for (var h in heroes) {
      final value = _getValue(h);
      if (value > max) max = value;
    }

    return max + (max * 0.2);
  }
}