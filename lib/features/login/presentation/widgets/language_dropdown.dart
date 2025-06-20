import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = context.read<LocalizationLocalDataSourceContract>();

    return BlocBuilder<LanguageCubit, LanguageChangedState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.localeCode,
                dropdownColor: Colors.grey[900],
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Icon(
                    Icons.language,
                    size: 30,
                    color: Colors.amber,
                  ),
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
                items: [
                  _buildDropdownItem('es', 'Español'),
                  _buildDivider(),
                  _buildDropdownItem('en', 'English'),
                ],
                onChanged: (value) async {
                  if (value != null && value != state.localeCode) {
                    await localization.cacheLocalLanguageCode(value);
                    context.read<LanguageCubit>().changeLanguage(value);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String text) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(text),
    );
  }

  DropdownMenuItem<String> _buildDivider() {
    return DropdownMenuItem<String>(
      enabled: false,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 1,
        color: Colors.grey[700],
      ),
    );
  }
}
