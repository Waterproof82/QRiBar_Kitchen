import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/config/di.dart';
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_data_source.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';
import 'package:qribar_cocina/data/data_sources/remote/listener_remote_data_source.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';
import 'package:qribar_cocina/features/app/app.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'package:qribar_cocina/features/login/data/repositories/login_repository_impl.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';

/// 🚀
/// A [StatelessWidget] which wraps the [App] with the necessary providers.
/// This widget handles dependency injection for repositories, data sources,
/// providers and blocs used throughout the application.
class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseDatabase _database = FirebaseDatabase.instance;

    return MultiProvider(
      /// 🌐 Global non-Bloc providers
      providers: [ChangeNotifierProvider(create: (_) => NavegacionProvider())],
      child: MultiRepositoryProvider(
        /// 📦 Repository and DataSource injection
        providers: [
          /// 🔐 Remote DataSource for Firebase Authentication
          RepositoryProvider<AuthRemoteDataSourceContract>(
            create: (_) => AuthRemoteDataSourceImpl(),
          ),

          /// 👤 Login repository using remote data source and singleton IdBarDataSource
          RepositoryProvider<LoginRepositoryContract>(
            create: (context) => LoginRepositoryImpl(
              context.read<AuthRemoteDataSourceContract>(),
              IdBarDataSource.instance,
            ),
          ),

          /// 📋 UseCase for Login business logic
          RepositoryProvider<LoginUseCase>(
            create: (context) =>
                LoginUseCase(context.read<LoginRepositoryContract>()),
          ),

          /// 🎧 Remote DataSource and Repository for Firebase listeners
          RepositoryProvider<ListenerRepositoryImpl>(
            create: (context) {
              final _listenerDataSource = ListenersRemoteDataSource(
                database: _database,
              );
              return ListenerRepositoryImpl(
                database: _database,
                dataSource: _listenerDataSource,
              );
            },
          ),

          /// ⚙️ Local DataSources for preferences and localization
          RepositoryProvider<PreferencesLocalDataSourceContract>(
            create: (_) => getIt.get<PreferencesLocalDataSourceContract>(),
          ),
          RepositoryProvider<LocalizationLocalDataSourceContract>(
            create: (context) => LocalizationLocalDataSource(
              preferences: context.read<PreferencesLocalDataSourceContract>(),
            ),
          ),
        ],
        child: MultiBlocProvider(
          /// 🧩 Blocs managing app state
          providers: [
            BlocProvider<ListenerBloc>(
              create: (context) => ListenerBloc(
                repository: context.read<ListenerRepositoryImpl>(),
                authRemoteDataSourceContract: context
                    .read<AuthRemoteDataSourceContract>(),
              ),
            ),
            BlocProvider<LoginFormBloc>(
              create: (context) => LoginFormBloc(
                loginUseCase: context.read<LoginUseCase>(),
                listenerBloc: context.read<ListenerBloc>(),
              ),
            ),
            BlocProvider<LanguageCubit>(
              create: (context) => LanguageCubit(
                context.read<LocalizationLocalDataSourceContract>(),
              ),
            ),
          ],
          child: App(),
        ),
      ),
    );
  }
}
