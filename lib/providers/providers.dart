import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listener_data_source_impl.dart';
import 'package:qribar_cocina/data/repositories/listener_repository_impl.dart';
import 'package:qribar_cocina/features/app/app.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'package:qribar_cocina/features/login/data/repositories/login_repository_impl.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/providers/bloc/listener_bloc.dart';
import 'package:qribar_cocina/providers/navegacion_provider.dart';

/// A [StatelessWidget] which wraps the [App] with the necessary providers.
class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavegacionProvider()),
      ],
      child: Builder(
        builder: (context) {
          final database = FirebaseDatabase.instance;

          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider<AuthRemoteDataSourceContract>(
                create: (_) => AuthRemoteDataSourceImpl(),
              ),
              RepositoryProvider<LoginRepositoryContract>(
                create: (context) => LoginRepositoryImpl(
                  context.read<AuthRemoteDataSourceContract>(),
                  IdBarDataSource.instance,
                ),
              ),
              RepositoryProvider<LoginUseCase>(
                create: (context) => LoginUseCase(context.read<LoginRepositoryContract>()),
              ),
              RepositoryProvider(
                create: (_) {
                  final navProvider = context.read<NavegacionProvider>();
                  final listenerDataSource = ListenersDataSourceImpl(
                    database: database,
                    navProvider: navProvider,
                  );
                  return ListenerRepositoryImpl(
                    database: database,
                    dataSource: listenerDataSource,
                  );
                },
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => LoginFormBloc(
                    loginUseCase: context.read<LoginUseCase>(),
                  ),
                ),
                BlocProvider(
                  create: (context) {
                    final listenerRepo = context.read<ListenerRepositoryImpl>();
                    return ListenerBloc(repository: listenerRepo)
                      ..add(
                        const ListenerEvent.startListening(),
                      );
                  },
                ),
              ],
              child: App(),
            ),
          );
        },
      ),
    );
  }
}
