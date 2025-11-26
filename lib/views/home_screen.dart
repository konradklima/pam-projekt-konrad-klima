import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/character_viewmodel.dart';
import 'widgets/character_list_item.dart';
import 'widgets/text_of_the_day.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterViewModel>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LORD OF THE RINGS')),
      body: Column(
        children: [
          const TextOfTheDay(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    hintText: 'Szukaj postaci...',
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    context.read<CharacterViewModel>().search(value);
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: Consumer<CharacterViewModel>(
                    builder: (context, viewModel, child) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: viewModel.races.length,
                        itemBuilder: (context, index) {
                          final race = viewModel.races[index];
                          final isSelected = race == viewModel.selectedRace;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(race),
                              selected: isSelected,
                              onSelected: (selected) {
                                viewModel.filterByRace(race);
                              },
                              backgroundColor: Theme.of(context).cardColor,
                              selectedColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.transparent,
                                ),
                              ),
                              showCheckmark: false,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CharacterViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading && viewModel.characters.isEmpty) {
                  return _buildLoading();
                }

                if (viewModel.errorMessage != null &&
                    viewModel.characters.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Color(0xFFC15A36),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF8B9190)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              viewModel.fetchCharacters(refresh: true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: const Color(0xFF0A0E0D),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Spróbuj ponownie',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (viewModel.characters.isEmpty) {
                  return const Center(child: Text('Nie znaleziono postaci.'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      viewModel.characters.length + (viewModel.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == viewModel.characters.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(
                            color: Color(0xFFC9B88D),
                          ),
                        ),
                      );
                    }
                    return CharacterListItem(
                      character: viewModel.characters[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: const Color(0xFF1C1E1A),
        highlightColor: const Color(0xFF2A2C28),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1E1A),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
