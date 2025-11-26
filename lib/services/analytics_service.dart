import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logSearch(String searchTerm) async {
    await _analytics.logEvent(
      name: 'search_character',
      parameters: {'search_term': searchTerm},
    );
  }

  Future<void> logViewCharacter(
    String characterName,
    String characterId,
  ) async {
    await _analytics.logEvent(
      name: 'view_character_details',
      parameters: {
        'character_name': characterName,
        'character_id': characterId,
      },
    );
  }

  Future<void> logFilterRace(String race) async {
    await _analytics.logEvent(name: 'filter_race', parameters: {'race': race});
  }
}
