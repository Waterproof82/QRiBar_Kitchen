import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_data_source_impl.dart';
import 'package:qribar_cocina/data/repositories/data_sources/remote/listener_repository_impl.dart';
import 'package:qribar_cocina/presentation/login/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/providers/bloc/listener_bloc.dart';
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
      ],
      child: Builder(
        builder: (context) {
          final productsService = context.read<ProductsService>();
          final database = FirebaseDatabase.instance;

          final listenerDataSource = ListenersDataSourceImpl(
            database: database,
            productService: productsService,
          );
          final listenerRepo = ListenerRepositoryImpl(database: database, dataSource: listenerDataSource);

          final listenerBloc = ListenerBloc(repository: listenerRepo);

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => LoginFormBloc(productsService: productsService),
              ),
              BlocProvider(
                create: (_) => listenerBloc..add(const ListenerEvent.startListening()),
              ),
            ],
            child: child,
          );
        },
      ),
    );
  }
}
