import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinopoisk/providers/movie_provider.dart';
import 'package:kinopoisk/widgets/movie_edit.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  void _openAddMovieOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (_) => EditMovie(movieId: widget.movieId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref
        .watch(moviesProvider)
        .firstWhere((movie) => movie.id == widget.movieId);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            onPressed: _openAddMovieOverlay,
            icon: const Icon(Icons.create),
          ),
          IconButton(
            onPressed: () {
              ref.read(moviesProvider.notifier).deleteMovie(movie);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Год релиза: ${movie.date.year.toString()}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Страна: ${movie.country}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Лорем ипсум долор сит амет, ет ерат популо оцурререт при, еяуидем детерруиссет цу цум, хас ет аутем оцурререт. Ет пер мутат афферт, пер ребум ехплицари еи, хас еи солеат омиттам сусципит. Амет меис путант еу меа, ин вим пертинах платонем еффициенди. Вих ассум лабитур те. Вел цу лаореет оффендит губергрен, алиенум аццусата персецути про ан.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
