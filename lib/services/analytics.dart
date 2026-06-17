import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  static final FirebaseAnalytics _analytics =
      FirebaseAnalytics.instance;

  static Future<void> log(String event) async {
    await _analytics.logEvent(name: event);
  }
}