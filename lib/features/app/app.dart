import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/config/app_theme.dart';
import 'package:qribar_cocina/app/extensions/l10n_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/app/router/app_router.dart';
import 'package:qribar_cocina/app/localization/cubit/language_cubit.dart';
import 'package:qribar_cocina/app/localization/cubit/language_state.dart';
import 'package:qribar_cocina/shared/utils/global_error_listener.dart';

final class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp.router(
          theme: AppTheme.theme(),
          debugShowCheckedModeBanner: false,
          locale: Locale(state.localeCode),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: AppRouter.router,
          onGenerateTitle: (context) => context.l10n.appName,
          builder: (context, child) =>
              GlobalErrorListener(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
