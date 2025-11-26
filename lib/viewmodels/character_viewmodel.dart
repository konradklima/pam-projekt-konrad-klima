import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

import '../services/analytics_service.dart';

class CharacterViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final AnalyticsService _analyticsService = AnalyticsService();

  List<Character> _characters = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _totalPages = 1;
  String _searchQuery = '';
  String _selectedRace = 'Wszystkie';
  final List<String> _races = [
    'Wszystkie',
    'Ulubione',
    'Human',
    'Elf',
    'Dwarf',
    'Hobbit',
    'Maiar',
    'Orc',
  ];

  Set<String> _favoriteIds = {};

  List<Character> get characters => _characters;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore =>
      _selectedRace != 'Ulubione' && _currentPage <= _totalPages;
  String get selectedRace => _selectedRace;
  List<String> get races => _races;

  bool isFavorite(String id) => _favoriteIds.contains(id);

  CharacterViewModel() {
    _init();
  }

  Future<void> _init() async {
    await _localStorageService.init();
    _favoriteIds = _localStorageService.getFavorites().toSet();
    fetchCharacters(refresh: true);
  }

  Future<void> toggleFavorite(String id) async {
    await _localStorageService.toggleFavorite(id);
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }

    if (_selectedRace == 'Ulubione') {
      fetchCharacters(refresh: true);
    } else {
      notifyListeners();
    }
  }

  Future<void> fetchCharacters({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _characters = [];
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_selectedRace == 'Ulubione') {
        final allCached = _localStorageService.getCharacters();
        final favoriteChars = allCached
            .where((c) => _favoriteIds.contains(c.id))
            .toList();

        if (_searchQuery.isNotEmpty) {
          _characters = favoriteChars
              .where(
                (c) =>
                    c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
        } else {
          _characters = favoriteChars;
        }
        _totalPages = 1;
      } else {
        final data = await _apiService.getCharacters(
          page: _currentPage,
          nameFilter: _searchQuery,
          raceFilter: _selectedRace,
        );

        final List<dynamic> docs = data['docs'];
        final List<Character> newCharacters = docs
            .map((json) => Character.fromJson(json))
            .toList();

        _totalPages = data['pages'];

        if (refresh) {
          _characters = newCharacters;
        } else {
          _characters.addAll(newCharacters);
        }

        await _localStorageService.saveCharacters(newCharacters);
        _currentPage++;
      }
    } catch (e) {
      _errorMessage =
          "Błąd pobierania danych. Pokazuję dane z pamięci podręcznej.";
      debugPrint("Error fetching data: $e");

      if (_characters.isEmpty) {
        final cached = _localStorageService.getCharacters();
        if (cached.isNotEmpty) {
          _characters = cached;

          if (_selectedRace != 'Wszystkie' && _selectedRace != 'Ulubione') {
            _characters = _characters
                .where((c) => c.race == _selectedRace)
                .toList();
          }
          if (_searchQuery.isNotEmpty) {
            _characters = _characters
                .where(
                  (c) =>
                      c.name.toLowerCase().contains(_searchQuery.toLowerCase()),
                )
                .toList();
          }
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    if (query.isNotEmpty) {
      _analyticsService.logSearch(query);
    }
    fetchCharacters(refresh: true);
  }

  void filterByRace(String race) {
    if (_selectedRace == race) return;
    _selectedRace = race;
    _analyticsService.logFilterRace(race);
    fetchCharacters(refresh: true);
  }

  Future<void> loadMore() async {
    if (hasMore && !_isLoading) {
      await fetchCharacters();
    }
  }
}
