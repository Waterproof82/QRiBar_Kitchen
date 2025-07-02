import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/config/app_theme.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/app/router/app_router.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/shared/widgets/global_error_listener.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageChangedState>(
      builder: (context, state) {
        return SafeArea(
          child: MaterialApp.router(
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            locale: Locale(state.localeCode),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: appRouter,
            onGenerateTitle: (context) => context.l10n.appName,
            builder: (context, child) {
              return GlobalErrorListener(
                child: child ?? const SizedBox.shrink(),
              );
            },
          ),
        );
      },
    );
  }
}
