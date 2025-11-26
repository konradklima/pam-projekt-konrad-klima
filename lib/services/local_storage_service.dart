import 'package:hive/hive.dart';
import '../models/character.dart';

class LocalStorageService {
  static const String _boxName = 'charactersBox';
  static const String _favoritesBoxName = 'favoritesBox';

  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Character>(_boxName);
    }
    if (!Hive.isBoxOpen(_favoritesBoxName)) {
      await Hive.openBox<String>(_favoritesBoxName);
    }
  }

  Box<Character> get _box => Hive.box<Character>(_boxName);
  Box<String> get _favoritesBox => Hive.box<String>(_favoritesBoxName);

  Future<void> saveCharacters(List<Character> characters) async {
    final Map<dynamic, Character> entries = {for (var c in characters) c.id: c};
    await _box.putAll(entries);
  }

  List<Character> getCharacters() {
    return _box.values.toList();
  }

  Character? getCharacter(String id) {
    return _box.get(id);
  }

  List<String> getFavorites() {
    return _favoritesBox.values.toList();
  }

  Future<void> toggleFavorite(String id) async {
    if (_favoritesBox.values.contains(id)) {
      final key = _favoritesBox.keys.firstWhere(
        (k) => _favoritesBox.get(k) == id,
      );
      await _favoritesBox.delete(key);
    } else {
      await _favoritesBox.add(id);
    }
  }

  Future<void> clear() async {
    await _box.clear();
    await _favoritesBox.clear();
  }
}
