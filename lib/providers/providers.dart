import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/presentation/login/provider/login_form_provider.dart';
import 'package:qribar_cocina/providers/products_provider.dart';
import 'package:qribar_cocina/providers/navegacion_model.dart';
import 'package:qribar_cocina/providers/listeners_provider.dart';

/// A [StatelessWidget] that wraps the app with the necessary providers.
class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => NavegacionModel()),
        ChangeNotifierProvider(create: (_) => ListenersProvider()),
      ],
      child: child,
    );
  }
}