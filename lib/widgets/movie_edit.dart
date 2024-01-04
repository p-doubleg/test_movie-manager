import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinopoisk/models/movie.dart';
import 'package:kinopoisk/providers/movies_notifier.dart';

class EditMovie extends ConsumerStatefulWidget {
  const EditMovie({
    super.key,
    required this.movieId,
  });

  final int movieId;

  @override
  ConsumerState<EditMovie> createState() => _EditMovieState();
}

class _EditMovieState extends ConsumerState<EditMovie> {
  late DateTime _selectedDate;
  late String _selectedCountry;
  final _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final movie = ref
        .read(moviesProvider)
        .firstWhere((movie) => movie.id == widget.movieId);

    _selectedDate = movie.date;
    _titleController.text = movie.title;
    _selectedCountry = movie.country;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _presentDatePicker(Movie movie) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              selectedDate: _selectedDate,
              onChanged: (DateTime dateTime) {
                setState(() {
                  _selectedDate = dateTime;
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = ref
        .watch(moviesProvider)
        .where((movie) => movie.id == widget.movieId)
        .toList()[0];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 13),
            child: TextField(
              controller: _titleController,
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Название'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                label: Text(
                  _selectedDate.year.toString(),
                ),
                onPressed: () {
                  _presentDatePicker(movie);
                },
                icon: const Icon(Icons.calendar_month),
              ),
              TextButton.icon(
                label: Text(
                  _selectedCountry,
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {
                  showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          _selectedCountry = country.displayNameNoCountryCode;
                        });
                      });
                },
                icon: const Icon(Icons.language),
              )
            ],
          ),
          TextButton(
            onPressed: () {
              ref.read(moviesProvider.notifier).editMovie(
                    movie,
                    _titleController.text,
                    _selectedDate,
                    _selectedCountry,
                  );
              Navigator.pop(context);
            },
            child: const Text('Отредактировать'),
          ),
        ],
      ),
    );
  }
}
