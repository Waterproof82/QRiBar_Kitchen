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
import 'package:qribar_cocina/data/data_sources/remote/listeners_remote_data_source_contract.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';
import 'package:qribar_cocina/features/app/app.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc_impl.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit_impl.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_contract.dart';
import 'package:qribar_cocina/features/login/data/data_sources/remote/auth_remote_data_source_impl.dart';
import 'package:qribar_cocina/features/login/data/repositories/login_repository_impl.dart';
import 'package:qribar_cocina/features/login/domain/repositories/login_repository_contract.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case.dart';
import 'package:qribar_cocina/features/login/domain/use_cases/login_use_case_impl.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc_impl.dart';

/// A final [StatelessWidget] which wraps the [App] with the necessary providers.
///
/// This widget handles dependency injection for repositories, data sources,
/// providers, and blocs used throughout the application.
///
final class AppProviders extends StatelessWidget {
  /// Creates a constant instance of [AppProviders].
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseDatabase database = FirebaseDatabase.instance;

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
                LoginUseCaseImpl(context.read<LoginRepositoryContract>()),
          ),

          /// 🎧 Remote DataSource and Repository for Firebase listeners
          /// The concrete data source is created and then injected into the repository.
          RepositoryProvider<ListenerRepository>(
            // Changed to contract
            create: (context) {
              final ListenersRemoteDataSourceContract listenerDataSource =
                  ListenersRemoteDataSource(database: database);
              return ListenerRepositoryImpl(
                database: database,
                dataSource: listenerDataSource,
              );
            },
          ),

          /// ⚙️ Local DataSources for preferences and localization
          /// Preferences data source is retrieved from a dependency injection container (getIt).
          RepositoryProvider<PreferencesLocalDataSourceContract>(
            create: (_) => getIt.get<PreferencesLocalDataSourceContract>(),
          ),

          /// Localization data source is created, injecting its preferences contract.
          RepositoryProvider<LocalizationLocalDataSourceContract>(
            create: (context) => LocalizationLocalDataSource(
              preferences: context.read<PreferencesLocalDataSourceContract>(),
            ),
          ),
        ],
        child: MultiBlocProvider(
          /// 🧩 Blocs managing app state
          providers: [
            /// Bloc for managing real-time listeners and data events.
            /// Injects the ListenerRepository contract and AuthRemoteDataSourceContract.
            BlocProvider<ListenerBloc>(
              create: (context) => ListenerBlocImpl(
                repository: context.read<ListenerRepository>(),
                authRemoteDataSourceContract: context
                    .read<AuthRemoteDataSourceContract>(),
              ),
            ),

            /// Bloc for managing login form state and logic.
            BlocProvider<LoginFormBloc>(
              create: (context) => LoginFormBlocImpl(
                loginUseCase: context.read<LoginUseCase>(),
                listenerBloc: context.read<ListenerBloc>(),
              ),
            ),

            /// Cubit for managing language selection and persistence.
            BlocProvider<LanguageCubit>(
              create: (context) => LanguageCubitImpl(
                context.read<LocalizationLocalDataSourceContract>(),
              ),
            ),
          ],
          child: const App(),
        ),
      ),
    );
  }
}
