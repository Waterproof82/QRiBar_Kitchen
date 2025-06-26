import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget child, {List<RepositoryProvider<dynamic>> repositories = const [], List<BlocProvider<dynamic>> blocs = const [], Locale? locale}) {
    Widget wrapped = child;

    if (blocs.isNotEmpty) {
      wrapped = MultiBlocProvider(providers: blocs, child: wrapped);
    }

    if (repositories.isNotEmpty) {
      wrapped = MultiRepositoryProvider(providers: repositories, child: wrapped);
    }

    return pumpWidget(
      MaterialApp(
        navigatorKey: Globals.navigatorKey,
        locale: locale,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        supportedLocales: const [Locale('en'), Locale('es')],
        home: Scaffold(body: wrapped),
      ),
    );
  }
}
