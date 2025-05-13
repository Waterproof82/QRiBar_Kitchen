import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';

class LanguageChangedState {
  final String localeCode;
  const LanguageChangedState({required this.localeCode});
}

class LanguageCubit extends Cubit<LanguageChangedState> {
  final LocalizationLocalDataSourceContract _localization;

  LanguageCubit(this._localization)
      : super(LanguageChangedState(
          localeCode: _localization.getCachedLocalLanguageCode(),
        ));

  void fetchLanguage() => emit(
        LanguageChangedState(
          localeCode: _localization.getCachedLocalLanguageCode(),
        ),
      );

  Locale get locale => Locale(state.localeCode);

  Future<void> changeLanguage(String localeCode) async {
    await _localization.cacheLocalLanguageCode(localeCode);
    emit(LanguageChangedState(localeCode: localeCode));
  }
}
