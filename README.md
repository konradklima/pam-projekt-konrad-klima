# LORD OF THE RINGS - Kompendium Postaci Śródziemia

Aplikacja mobilna **LORD OF THE RINGS** to interaktywne kompendium postaci z uniwersum Tolkiena. Zanurz się w mrocznym, eleganckim interfejsie inspirowanym królestwami Śródziemia i odkryj szczegóły o swoich ulubionych bohaterach - od elfich władców po hobbitów z Shire.

## Opis Aplikacji

LORD OF THE RINGS to zaawansowana aplikacja Flutter stworzona dla fanów dzieł J.R.R. Tolkiena. Aplikacja oferuje:

### Kluczowe Funkcjonalności

- **Przeglądanie Postaci** - Eksploruj setki postaci z Middle-earth w eleganckim, responsywnym interfejsie
- **Inteligentne Wyszukiwanie** - Błyskawiczne znajdowanie postaci po nazwie w czasie rzeczywistym
- **Filtrowanie po Rasach** - Przeglądaj postacie według rasy: Ludzie, Elfy, Krasnoludy, Hobbici, Maiarowie i Orkowie
- **Szczegółowe Profile** - Poznaj historię każdej postaci: pochodzenie, rodzina, daty życia
- **Tryb Offline** - Przeglądaj wcześniej załadowane dane bez połączenia z internetem
- **Firebase Integration** - Zaawansowana analityka użytkownika i monitoring błędów
- **Mroczny Motyw UI** - Unikalna paleta kolorów inspirowana Śródziemiem (czarny Mordor, złoto Mithril, kamień Gondoru)

### Architektura

Aplikacja wykorzystuje profesjonalny wzorzec **MVVM (Model-View-ViewModel)** z zarządzaniem stanem opartym na **Provider**, zapewniając czytelny, testowalny i skalowalny kod.

#### Stack Technologiczny

- **Flutter 3.x** - Wieloplatformowy framework UI
- **Dart** - Język programowania
- **Provider** - Zarządzanie stanem
- **Hive** - Lokalna baza danych NoSQL (persystencja offline)
- **Firebase Suite** - Analytics + Crashlytics
- **The One API** - Zewnętrzne źródło danych

## Źródło Danych - The One API

Aplikacja korzysta z oficjalnego **The One API** - największej publicznej bazy danych o uniwersum Tolkiena.

### Szczegóły API

- **Nazwa:** The One API (Lord of the Rings API)
- **Dokumentacja:** [https://the-one-api.dev/](https://the-one-api.dev/)
- **Wersja:** v2
- **Endpoint Bazy:** `https://the-one-api.dev/v2`
- **Uwierzytelnienie:** Bearer Token (klucz API)
- **Wykorzystywane Zasoby:**
  - `/character` - Lista wszystkich postaci
  - `/character/{id}` - Szczegóły pojedynczej postaci
  - Paginacja, filtrowanie i wyszukiwanie

### Pobierane Dane o Postaciach

Dla każdej postaci aplikacja pobiera i wyświetla minimum 5 pól danych:

1. **Nazwa** (`name`) - Imię postaci
2. **Rasa** (`race`) - Przynależność rasowa (Human, Elf, Dwarf, Hobbit, Maiar, Orc)
3. **Płeć** (`gender`) - Płeć postaci
4. **Data Urodzenia** (`birth`) - Informacje o narodzinach
5. **Data Śmierci** (`death`) - Informacje o śmierci (jeśli dotyczy)
6. **Małżonek** (`spouse`) - Informacje o partnerze życiowym
7. **Wiki URL** (`wikiUrl`) - Link do strony wiki dla pogłębionej wiedzy

## Instrukcja Uruchomienia

### Wymagania Wstępne

Przed uruchomieniem aplikacji upewnij się, że masz zainstalowane:

- **Flutter SDK** (wersja 3.0 lub nowsza) - [Instrukcja instalacji](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (instalowany automatycznie z Flutter)
- **Android Studio** lub **Xcode** (w zależności od platformy docelowej)
- **Git** - do klonowania repozytorium

### Krok po Kroku

#### 1. Klonowanie Repozytorium

```bash
git clone https://github.com/konradklima/pam-projekt-konrad-klima.git
cd projekt_konrad_klima_pam
```

#### 2. Instalacja Zależności

```bash
flutter pub get
```

Ta komenda pobierze wszystkie wymagane pakiety zdefiniowane w `pubspec.yaml`.

#### 3. Generowanie Kodu Hive

Aplikacja używa Hive do persystencji danych. Wygeneruj wymagane pliki adaptera:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. Konfiguracja Firebase (Opcjonalnie)

Aby w pełni wykorzystać funkcje Firebase Analytics i Crashlytics:

1. Utwórz projekt w [Firebase Console](https://console.firebase.google.com/)
2. Dodaj aplikację Android/iOS
3. Pobierz `google-services.json` (Android) lub `GoogleService-Info.plist` (iOS)
4. Umieść pliki w odpowiednich katalogach:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

Uwaga: Aplikacja działa także bez Firebase, ale funkcje analityczne będą nieaktywne.

#### 5. Uruchomienie Aplikacji

##### Na Emulatorze/Symulatorze

```bash
# Wyświetl dostępne urządzenia
flutter devices

# Uruchom na wybranym urządzeniu
flutter run -d <device_id>
```

##### Na Fizycznym Urządzeniu

1. Włącz tryb debugowania USB (Android) lub tryb deweloperski (iOS)
2. Podłącz urządzenie do komputera
3. Uruchom: `flutter run`

##### Tryb Release (Produkcyjny)

```bash
# Android APK
flutter build apk --release

# iOS (wymagany macOS)
flutter build ios --release
```

## Wspierane Platformy

Aplikacja została zaprojektowana i przetestowana dla następujących platform:

| Platforma | Wsparcie | Minimalna Wersja | Uwagi |
|-----------|----------|------------------|-------|
| **Android** |  Pełne | Android 5.0 (API 21) | Zalecane: Android 8.0+ |
| **iOS** |  Pełne | iOS 12.0 | Zalecane: iOS 14.0+ |
| **Windows** |  Eksperymentalne | Windows 10 | Wymaga konfiguracji |
| **macOS** |  Eksperymentalne | macOS 10.14 | Wymaga konfiguracji |
| **Web** |  Ograniczone | - | Części funkcji offline mogą nie działać |
| **Linux** |  Eksperymentalne | - | Wymaga dodatkowych zależności |

### Rekomendacje Wydajnościowe

Dla optymalnego doświadczenia zalecamy:

- **Android:** Wersja 8.0 (Oreo) lub nowsza, min. 2GB RAM
- **iOS:** iPhone 7 / iOS 14 lub nowsze, min. 2GB RAM
- **Połączenie internetowe:** Wymagane przy pierwszym uruchomieniu do pobrania danych

## Funkcje Firebase

Aplikacja wykorzystuje Firebase do zaawansowanego monitoringu i analityki:

### Firebase Analytics

Śledzone niestandardowe wydarzenia (Custom Events):

- `search_character` - Wyszukiwanie postaci (parametr: query)
- `filter_race` - Filtrowanie po rasie (parametr: race)
- `view_character_details` - Wyświetlenie szczegółów postaci (parametry: character_name, character_id)

### Firebase Crashlytics

- Automatyczne raportowanie błędów krytycznych
- Śledzenie awarii aplikacji w czasie rzeczywistym
- Stack trace dla szybkiej diagnostyki

## Struktura Projektu

```
lib/
├── models/           # Modele danych (Character + Hive adaptery)
├── services/         # Logika biznesowa (API, Storage, Analytics)
├── viewmodels/       # ViewModels (logika stanu + Provider)
├── views/            # Widoki UI (ekrany + komponenty)
│   └── widgets/      # Reużywalne komponenty
└── main.dart         # Punkt wejścia aplikacji
```

## Testowanie

```bash
# Uruchom wszystkie testy
flutter test

# Testy z pokryciem kodu
flutter test --coverage
```

## Główne Zależności

- `provider: ^6.1.2` - Zarządzanie stanem
- `http: ^1.2.2` - Komunikacja HTTP
- `hive: ^2.2.3` + `hive_flutter: ^1.1.0` - Baza danych NoSQL
- `firebase_core: ^3.9.0` - Inicjalizacja Firebase
- `firebase_analytics: ^11.3.5` - Analityka
- `firebase_crashlytics: ^4.2.0` - Monitoring błędów
- `shimmer: ^3.0.0` - Efekty ładowania
- `cached_network_image: ^3.4.1` - Cache obrazów
- `url_launcher: ^6.3.1` - Otwieranie linków zewnętrznych

## Autor

**Konrad Klima**  
Cyberbezpieczeństwo - Programowanie Aplikacji Mobilnych
