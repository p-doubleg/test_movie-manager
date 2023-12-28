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
    // Note: setting a unique directory is recommended if running on desktop
    // platforms. If none is specified, the default directory is created in the
    // users documents directory, which will not be unique between apps.
    // On mobile this is typically fine, as each app has its own directory
    // structure.

    // Note: set macosApplicationGroup for sandboxed macOS applications, see the
    // info boxes at https://docs.objectbox.io/getting-started for details.

    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(
        directory:
            p.join((await getApplicationDocumentsDirectory()).path, "obx-demo"),
        macosApplicationGroup: "objectbox.demo");
    return ObjectBox._create(store);
  }

  List<Movie> getMovies() {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries

    // final builder = _movieBox.query();

    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.

    // return builder
    //     .watch(triggerImmediately: true)
    //     // Map it to a list of notes to be used by a StreamBuilder.
    //     .map((query) => query.find());
    return _movieBox.getAll();
  }

  Future<void> addMovie(Movie movie) => _movieBox.putAsync(movie);

  Future<void> removeMovie(int id) => _movieBox.removeAsync(id);

  Movie? getMovie(int id) => _movieBox.get(id);

  void editMovie(int id, String newTitle, DateTime newYear, String newCountry) {
    final movie = _movieBox.get(id);
    movie?.title = newTitle;
    movie?.date = newYear;
    movie?.country = newCountry;
    _movieBox.put(movie!);
  }

  void _putDemoData() {
    _movieBox.putManyAsync(allMovies);
  }
}
