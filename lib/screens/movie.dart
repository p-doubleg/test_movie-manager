import 'package:flutter/material.dart';
import 'package:kinopoisk/providers/movie_provider.dart';
import 'package:kinopoisk/providers/search_provider.dart';
import 'package:kinopoisk/widgets/movie_card.dart';
import 'package:kinopoisk/widgets/movie_new.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoviesScreen extends ConsumerStatefulWidget {
  const MoviesScreen({super.key});

  @override
  ConsumerState<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends ConsumerState<MoviesScreen> {
  void _openAddMovieOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (_) => const NewMovie(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(filteredMoviesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        actions: [
          IconButton(
            onPressed: _openAddMovieOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TextField(
              onChanged: (searchInput) => ref
                  .watch(searchProvider.notifier)
                  .setSearchInput(searchInput),
              decoration: const InputDecoration(suffixIcon: Icon(Icons.search)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, index) {
                return MovieCard(
                  movieId: movies[index].id,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
