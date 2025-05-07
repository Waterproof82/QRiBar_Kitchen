import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qribar_cocina/l10n/l10n.dart';
import 'package:qribar_cocina/routes/app_routes.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green[700],
          scaffoldBackgroundColor: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => context.l10n.appName,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
      ),
    );
  }
}
