import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class TextOfTheDay extends StatefulWidget {
  const TextOfTheDay({super.key});

  @override
  State<TextOfTheDay> createState() => _TextOfTheDayState();
}

class _TextOfTheDayState extends State<TextOfTheDay> {
  static const List<String> _quotes = [
    "Not all those who wander are lost.",
    "Even the smallest person can change the course of the future.",
    "All we have to decide is what to do with the time that is given us.",
    "The world is indeed full of peril, and in it there are many dark places; but still there is much that is fair.",
    "Moonlight drowns out all but the brightest stars.",
    "Deeds will not be less valiant because they are unpraised.",
    "Faithless is he that says farewell when the road darkens.",
    "It is a strange fate that we should suffer so much fear and doubt over so small a thing.",
    "I would rather share one lifetime with you than face all the ages of this world alone.",
  ];

  late String _currentQuote;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateQuote();

    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      setState(() {
        _updateQuote();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateQuote() {
    final random = Random();
    _currentQuote = _quotes[random.nextInt(_quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF252525)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "WYBRANY CYTAT",
                style: TextStyle(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"$_currentQuote"',
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
              fontFamily: 'Georgia',
            ),
          ),
        ],
      ),
    );
  }
}
