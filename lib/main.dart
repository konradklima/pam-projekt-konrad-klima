import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'viewmodels/character_viewmodel.dart';
import 'views/home_screen.dart';
import 'models/character.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CharacterAdapter());

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e) {
    debugPrint("Firebase initialization failed (likely missing config): $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CharacterViewModel())],
      child: MaterialApp(
        title: 'LORD OF THE RINGS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFD4AF37),
          scaffoldBackgroundColor: const Color(0xFF121212),
          cardColor: const Color(0xFF1E1E1E),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFD4AF37),
            secondary: Color(0xFFC9B88D),
            surface: Color(0xFF1E1E1E),

            onPrimary: Colors.black,
            onSurface: Color(0xFFE0E0E0),
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
              letterSpacing: 1.2,
              fontFamily: 'Serif',
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
              letterSpacing: 0.5,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFFE0E0E0),
              height: 1.5,
            ),
            bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFA0A0A0)),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
              letterSpacing: 1.5,
            ),
            iconTheme: IconThemeData(color: Color(0xFFD4AF37)),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF2C2C2C),
            hintStyle: const TextStyle(color: Color(0xFF808080)),
            prefixIconColor: const Color(0xFFD4AF37),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1),
            ),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
