import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/l10n/l10n.dart';
import 'package:qribar_cocina/app/routes/app_routes.dart';

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
        scaffoldMessengerKey: Globals.rootScaffoldMessengerKey,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
      ),
    );
  }
}
