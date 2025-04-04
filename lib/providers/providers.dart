import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/datasources/remote_data_source/listeners_data_source.dart';
import 'package:qribar_cocina/presentation/login/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';
import 'package:qribar_cocina/providers/products_provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsService()),
        ChangeNotifierProvider(create: (_) => NavegacionProvider()),
        ChangeNotifierProvider(create: (_) => ListenersDataSource()),
      ],
      child: Builder(
        builder: (context) {
          final productsService = context.read<ProductsService>();

          return BlocProvider(
            create: (_) => LoginFormBloc(productsService: productsService),
            child: child,
          );
        },
      ),
    );
  }
}
