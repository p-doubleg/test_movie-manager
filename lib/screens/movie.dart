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
  String? _searchInput;

  @override
  void dispose() {
    super.dispose();
  }

  void _openAddMovieOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const NewMovie(),
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
              itemBuilder: (ctx, index) {
                if (_searchInput != null) {
                  if (movies[index]
                      .title
                      .toLowerCase()
                      .contains(_searchInput!.toLowerCase())) {
                    return MovieCard(
                      movieId: movies[index].id,
                    );
                  } else {
                    return null;
                  }
                } else {
                  return MovieCard(
                    movieId: movies[index].id,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
