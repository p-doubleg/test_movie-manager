import 'package:objectbox/objectbox.dart';

@Entity()
class Movie {
  @Id()
  int id = 0;
  String title;
  DateTime date;
  String country;

  Movie({
    required this.title,
    required this.date,
    required this.country,
  });

  Movie copyWith(
    String title,
    DateTime date,
    String country,
  ) =>
      Movie(
        title: title,
        date: date,
        country: country,
      );
}
