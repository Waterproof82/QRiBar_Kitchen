import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';

/// A final [StatelessWidget] that provides a language selection dropdown.
/// It allows users to change the application's locale and persists the selection.
final class LanguageDropdown extends StatelessWidget {
  /// Creates a constant instance of [LanguageDropdown].
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder listens to LanguageCubit to rebuild when the locale changes.
    return BlocBuilder<LanguageCubit, LanguageChangedState>(
      builder: (context, state) {
        // Access the localization data source without listening, as it's used in onChanged callback.
        final LocalizationLocalDataSourceContract localization = context
            .read<LocalizationLocalDataSourceContract>();

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.greySoft, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.black,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: state.localeCode,
                dropdownColor: AppColors.black,
                icon: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.language,
                    size: 30,
                    color: AppColors.onSurface,
                  ),
                ),
                style: const TextStyle(
                  color: AppColors.onPrimary,
                  fontSize: 18,
                ),
                items: [
                  _buildDropdownItem('es', 'Español'),
                  _buildDivider(),
                  _buildDropdownItem('en', 'English'),
                ],
                onChanged: (value) async {
                  if (value != null && value != state.localeCode) {
                    // Cache the new locale and then update the LanguageCubit.
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

  /// Builds a [DropdownMenuItem] for a language option.
  ///
  /// [value]: The locale code (e.g., 'es', 'en').
  /// [text]: The display name of the language.
  DropdownMenuItem<String> _buildDropdownItem(String value, String text) {
    return DropdownMenuItem<String>(value: value, child: Text(text));
  }

  /// Builds a [DropdownMenuItem] that acts as a visual divider.
  DropdownMenuItem<String> _buildDivider() {
    return DropdownMenuItem<String>(
      enabled: false, // Make the divider non-selectable
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 1,
        color: AppColors.textHint,
      ),
    );
  }
}
