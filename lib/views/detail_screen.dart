import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import '../viewmodels/character_viewmodel.dart';
import '../models/character.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // Log view event
    FirebaseAnalytics.instance.logEvent(
      name: 'view_character_details',
      parameters: {
        'character_name': character.name,
        'character_id': character.id,
      },
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: [
              Consumer<CharacterViewModel>(
                builder: (context, viewModel, child) {
                  final isFav = viewModel.isFavorite(character.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    onPressed: () {
                      viewModel.toggleFavorite(character.id);
                    },
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                character.name,
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Hero(
                      tag: 'character-icon-${character.id}',
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.5),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            character.name.isNotEmpty
                                ? character.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 60,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(context, [
                    _buildInfoRow(
                      context,
                      'Rasa',
                      character.race,
                      Icons.person,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      'Płeć',
                      character.gender,
                      Icons.transgender,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      'Urodzony/a',
                      character.birth,
                      Icons.cake,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      'Zmarł/a',
                      character.death,
                      Icons.church,
                    ),
                    const Divider(height: 24),
                    _buildInfoRow(
                      context,
                      'Małżonek/ka',
                      character.spouse,
                      Icons.favorite,
                    ),
                  ]),
                  if (character.wikiUrl.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () => _launchUrl(character.wikiUrl),
                      icon: const Icon(Icons.public),
                      label: const Text('Zobacz Wiki'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : 'Brak danych',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      debugPrint('Could not launch $url');
    }
  }
}
