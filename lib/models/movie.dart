import 'package:objectbox/objectbox.dart';
// import 'package:uuid/uuid.dart';

// const uuid = Uuid();

// class Movie {
//   Movie({
//     required this.title,
//     required this.date,
//     required this.country,
//   }) : id = uuid.v4();

//   final String id;
//   String title;
//   DateTime date;
//   Country country;
// }

@Entity()
class Movie {
  @Id()
  int id = 0;
  String title;
  DateTime date;
  String country;

  Movie({required this.title, required this.date, required this.country});
}
