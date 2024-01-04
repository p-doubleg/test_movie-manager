import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinopoisk/providers/movie_provider.dart';
import 'package:kinopoisk/screens/movie_details.dart';

class MovieCard extends ConsumerWidget {
  const MovieCard({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie =
        ref.watch(moviesProvider).firstWhere((movie) => movie.id == movieId);

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => MovieDetailsScreen(
                movieId: movieId,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  movie.title,
                  style: const TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 30),
              Text(
                '${movie.date.year.toString()} год',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
