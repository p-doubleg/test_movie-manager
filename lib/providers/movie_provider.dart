import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinopoisk/main.dart';
import 'package:kinopoisk/models/movie.dart';
import 'package:kinopoisk/providers/search_provider.dart';

final movies = objectbox.getMovies();

class MoviesNotifier extends StateNotifier<List<Movie>> {
  MoviesNotifier() : super(movies);

  // Movie getMovie(int id) {
  //   return state.where((movie) => movie.id == id).toList()[0];
  // }

  void addMovie(
      {required String title,
      required String country,
      required DateTime year}) {
    objectbox.addMovie(Movie(title: title, date: year, country: country));

    state = [...state, Movie(title: title, date: year, country: country)];
  }

  void deleteMovie(Movie movie) {
    objectbox.removeMovie(movie.id);

    state = state.where((m) => m != movie).toList();
  }

  void editMovie(
      Movie movie, String newTitle, DateTime newYear, String newCountry) {
    objectbox.editMovie(movie.id, newTitle, newYear, newCountry);

    state = state.map((m) {
      if (m == movie) {
        movie.title = newTitle;
        movie.country = newCountry;
        movie.date = newYear;
        return movie;
      }
      return m;
    }).toList();
  }
}

final moviesProvider =
    StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  return MoviesNotifier();
});

final filteredMoviesProvider = Provider((ref) {
  final movies = ref.watch(moviesProvider);
  final searchInput = ref.watch(searchProvider);

  if (searchInput == '') {
    return movies;
  }

  final m = movies.where((movie) {
    return movie.title.toLowerCase().contains(searchInput.toLowerCase());
  }).toList();

  return m;
});
