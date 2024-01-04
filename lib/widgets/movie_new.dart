import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinopoisk/providers/movie_provider.dart';

class NewMovie extends ConsumerStatefulWidget {
  const NewMovie({super.key});

  @override
  ConsumerState<NewMovie> createState() => _NewMovieState();
}

class _NewMovieState extends ConsumerState<NewMovie> {
  DateTime? _selectedDate;
  Country? _selectedCountry;
  final _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
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
              selectedDate: _selectedDate ?? DateTime.now(),
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

  _showDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ошибка'),
        content: const Text('Убедитесь что все поля заполнены.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('ОК'))
        ],
      ),
    );
  }

  void _submitMovieData() {
    if (_titleController.text.trim().isEmpty ||
        _selectedCountry == null ||
        _selectedDate == null) {
      _showDialog();
      return;
    }
    ref.read(moviesProvider.notifier).addMovie(
          title: _titleController.text,
          country: _selectedCountry!.displayNameNoCountryCode,
          year: _selectedDate!,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                label: Text(_selectedDate != null
                    ? _selectedDate!.year.toString()
                    : 'Год'),
                onPressed: _presentDatePicker,
                icon: const Icon(Icons.calendar_month),
              ),
              TextButton.icon(
                label: Text(
                  _selectedCountry != null
                      ? _selectedCountry!.displayNameNoCountryCode
                      : 'Страна',
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () {
                  showCountryPicker(
                      context: context,
                      onSelect: (Country country) {
                        setState(() {
                          _selectedCountry = country;
                        });
                      });
                },
                icon: const Icon(Icons.language),
              )
            ],
          ),
          TextButton(
            onPressed: _submitMovieData,
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }
}
