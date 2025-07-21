import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:qribar_cocina/app/config/di.dart'; // Assuming getIt is configured here
// --- Shared Data Sources & Repositories (ensure these paths are correct for your project structure) ---
// If these are indeed shared and not specific to a single module, their paths might be like this.
import 'package:qribar_cocina/data/data_sources/local/id_bar_data_source.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_data_source.dart';
import 'package:qribar_cocina/data/data_sources/local/localization_local_datasource_contract.dart';
import 'package:qribar_cocina/data/data_sources/local/preferences_local_datasource_contract.dart';
import 'package:qribar_cocina/data/data_sources/remote/listener_remote_data_source.dart';
import 'package:qribar_cocina/data/data_sources/remote/listeners_remote_data_source_contract.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository.dart';
import 'package:qribar_cocina/data/repositories/remote/listener_repository_impl.dart';
// --- Core Modules Imports ---
import 'package:qribar_cocina/features/app/app.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc.dart';
import 'package:qribar_cocina/features/app/bloc/listener_bloc_impl.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit.dart';
import 'package:qribar_cocina/features/app/cubit/language_cubit_impl.dart';
import 'package:qribar_cocina/features/app/providers/navegacion_provider.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/biometric_auth_data_source_impl.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/biometric_auth_data_source.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/secure_credential_storage_data_source.dart';
import 'package:qribar_cocina/features/biometric/data/data_sources/local/secure_credential_storage_data_source_impl.dart';
import 'package:qribar_cocina/features/biometric/data/repositories/biometric_auth_repository_impl.dart';
import 'package:qribar_cocina/features/biometric/domain/repositories/biometric_auth_repository.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/authenticate_biometric_use_case.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/authenticate_biometric_use_case_impl.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/clear_biometric_credentials_use_case.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/clear_biometric_credentials_use_case_impl.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/save_biometric_credentials_use_case.dart';
import 'package:qribar_cocina/features/biometric/domain/use_cases/save_biometric_credentials_use_case_impl.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
// --- Login Module Imports ---
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
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        // Core Flutter dependencies required by Data Sources
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        Provider<LocalAuthentication>(create: (_) => LocalAuthentication()),
      ],
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

          // --- Fingerprint Authentication Module Dependencies ---

          // Data Sources for Biometric Module
          RepositoryProvider<SecureCredentialStorageDataSource>(
            create: (context) => SecureCredentialStorageDataSourceImpl(
              secureStorage: context
                  .read<FlutterSecureStorage>(), // Inject FlutterSecureStorage
            ),
          ),
          RepositoryProvider<BiometricAuthDataSource>(
            create: (context) => BiometricAuthDataSourceImpl(
              auth: context
                  .read<LocalAuthentication>(), // Inject LocalAuthentication
            ),
          ),

          // Repository for Biometric Module (THIS WAS THE MISSING PIECE!)
          RepositoryProvider<BiometricAuthRepository>(
            create: (context) => BiometricAuthRepositoryImpl(
              biometricDataSource: context.read<BiometricAuthDataSource>(),
              secureStorageDataSource: context
                  .read<SecureCredentialStorageDataSource>(),
              loginUseCase: context
                  .read<LoginUseCase>(), // Correctly pass LoginUseCase
            ),
          ),

          // Use Cases for Biometric Module
          RepositoryProvider<AuthenticateBiometricUseCase>(
            create: (context) => AuthenticateWithBiometricsUseCaseImpl(
              repository: context.read<BiometricAuthRepository>(),
            ),
          ),
          RepositoryProvider<SaveBiometricCredentialsUseCase>(
            create: (context) => SaveBiometricCredentialsUseCaseImpl(
              repository: context.read<BiometricAuthRepository>(),
            ),
          ),
          RepositoryProvider<ClearBiometricCredentialsUseCase>(
            create: (context) => ClearBiometricCredentialsUseCaseImpl(
              repository: context.read<BiometricAuthRepository>(),
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

            /// Cubit for managing language selection and persistence.
            BlocProvider<LanguageCubit>(
              create: (context) => LanguageCubitImpl(
                context.read<LocalizationLocalDataSourceContract>(),
              ),
            ),

            // New: BiometricAuthBloc (Provided BEFORE LoginFormBloc)
            BlocProvider<BiometricAuthBloc>(
              create: (context) => BiometricAuthBloc(
                authenticateUseCase: context
                    .read<AuthenticateBiometricUseCase>(),
                saveCredentialsUseCase: context
                    .read<SaveBiometricCredentialsUseCase>(),
                clearCredentialsUseCase: context
                    .read<ClearBiometricCredentialsUseCase>(),
                listenerBloc: context.read<ListenerBloc>(),
              ),
            ),

            /// Bloc for managing login form state and logic.
            // Provided AFTER BiometricAuthBloc as it has a dependency on it.
            BlocProvider<LoginFormBloc>(
              create: (context) => LoginFormBlocImpl(
                loginUseCase: context.read<LoginUseCase>(),
                listenerBloc: context.read<ListenerBloc>(),
                biometricAuthBloc: context
                    .read<
                      BiometricAuthBloc
                    >(), // Correctly inject BiometricAuthBloc
              ),
            ),
          ],
          child: const App(),
        ),
      ),
    );
  }
}
