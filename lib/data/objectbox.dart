import 'package:kinopoisk/data/dummy_data.dart';
import 'package:kinopoisk/models/movie.dart';
import 'package:kinopoisk/objectbox.g.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ObjectBox {
  late final Store _store;
  late final Box<Movie> _movieBox;

  ObjectBox._create(this._store) {
    _movieBox = Box<Movie>(_store);

    if (_movieBox.isEmpty()) {
      _putDemoData();
    }
  }

  static Future<ObjectBox> create() async {
    final store = await openStore(
        directory:
            p.join((await getApplicationDocumentsDirectory()).path, 'obx-demo'),
        macosApplicationGroup: 'objectbox.demo');
    return ObjectBox._create(store);
  }

  List<Movie> getMovies() {
    return _movieBox.getAll();
  }

  Future<void> addMovie(Movie movie) => _movieBox.putAsync(movie);

  Future<void> removeMovie(int id) => _movieBox.removeAsync(id);

  Movie? getMovie(int id) => _movieBox.get(id);

  void editMovie(
    int id,
    String newTitle,
    DateTime newYear,
    String newCountry,
  ) {
    final movie = _movieBox.get(id);
    if (movie != null) {
      movie.title = newTitle;
      movie.date = newYear;
      movie.country = newCountry;
      _movieBox.put(movie);
    }
  }

  void _putDemoData() {
    _movieBox.putManyAsync(allMovies);
  }
}
