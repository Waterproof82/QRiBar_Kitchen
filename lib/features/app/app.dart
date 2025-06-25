import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qribar_cocina/app/config/app_theme.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/l10n/l10n.dart';
import 'package:qribar_cocina/app/routes/app_routes.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/shared/widgets/global_error_listener.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageChangedState>(
      builder: (context, state) {
        return SafeArea(
          child: MaterialApp(
            navigatorKey: Globals.navigatorKey,
            theme: appTheme,
            debugShowCheckedModeBanner: false,
            locale: Locale(state.localeCode),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
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
