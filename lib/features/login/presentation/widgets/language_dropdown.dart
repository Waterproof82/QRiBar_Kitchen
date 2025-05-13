import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';

class LanguageDropdown extends StatefulWidget {
  @override
  State<LanguageDropdown> createState() => LanguageDropdownState();
}

class LanguageDropdownState extends State<LanguageDropdown> {
  String _selectedLang = 'es';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final localization = context.read<LocalizationLocalDataSourceContract>();
      final lang = localization.getCachedLocalLanguageCode();
      if (lang != _selectedLang) {
        setState(() {
          _selectedLang = lang;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = context.read<LocalizationLocalDataSourceContract>();

    return DropdownButton<String>(
      value: _selectedLang,
      dropdownColor: Colors.black,
      icon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: const Icon(
          Icons.language,
          size: 30,
          color: Colors.amber,
        ),
      ),
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(
          value: 'es',
          child: Text(
            'Español',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        DropdownMenuItem(
          value: 'en',
          child: Text(
            'English',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
      onChanged: (value) async {
        if (value != null && value != _selectedLang) {
          setState(() {
            _selectedLang = value;
          });
          await localization.cacheLocalLanguageCode(value);
          context.read<LanguageCubit>().changeLanguage(value);
        }
      },
    );
  }
}
