import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/const/app_constants.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_bloc.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_event.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_state.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_event.dart';
import 'package:qribar_cocina/features/biometric/presentation/helpers/biometric_helpers.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/features/login/presentation/ui/input_decoration.dart';

part '../helpers/login_form_helpers.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginFormBloc, LoginFormState>(
          listener: (context, state) {
            state.maybeMap(
              authenticated: (authState) {
                if (authState.sessionRestored) {
                  context.read<AuthBloc>().add(
                    const AuthEvent.sessionRestored(),
                  );
                } else {
                  context.read<AuthBloc>().add(
                    AuthEvent.loginSucceeded(
                      email: authState.email,
                      password: _passwordCtrl.text,
                    ),
                  );
                }
              },
              orElse: () {},
            );
          },
        ),

        BlocListener<AuthBloc, AuthState>(
          listener: (_, state) {
            state.maybeWhen(
              authenticated: () {
                context.goTo(AppRouteEnum.cocinaGeneral);
              },
              onboardingRequired: (email, password) {
                context.goTo(
                  AppRouteEnum.onboarding,
                  extra: {'email': email, 'password': password},
                );
              },
              biometricSetupRequired: (email, password) {
                context.read<BiometricAuthBloc>().add(
                  PromptForSetup(email: email, password: password),
                );
                showBiometricSetupDialog(
                  navigatorKey:
                      Globals.navigatorKey, // El contexto local es suficiente
                  bloc: context.read<BiometricAuthBloc>(),
                  l10n: AppLocalizations.of(context),
                  email: email,
                  password: password,
                );
              },
              orElse: () {},
            );
          },
        ),
      ],
      child: _buildForm(context, l10n),
    );
  }

  Widget _buildForm(BuildContext context, AppLocalizations l10n) {
    final loginBloc = context.read<LoginFormBloc>();

    return BlocBuilder<LoginFormBloc, LoginFormState>(
      builder: (context, state) {
        final isLoading = state.maybeMap(
          loading: (_) => true,
          orElse: () => false,
        );
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailCtrl,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'xxxx@qribar.es',
                    labelText: l10n.email,
                    prefixIcon: Icons.alternate_email_rounded,
                  ),
                  onChanged: (value) => loginBloc.add(EmailChanged(value)),
                  validator: (value) {
                    final regExp = RegExp(AppConstants.emailPattern);
                    return regExp.hasMatch(value ?? '')
                        ? null
                        : l10n.emailError;
                  },
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: AppSizes.p32),
                TextFormField(
                  controller: _passwordCtrl,
                  autocorrect: false,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '*****',
                    labelText: l10n.password,
                    prefixIcon: Icons.lock_clock_outlined,
                  ),
                  // onChanged: (value) => loginBloc.add(PasswordChanged(value)),
                  validator: (value) => (value != null && value.length >= 6)
                      ? null
                      : l10n.passwordError,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: AppSizes.p32),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.p10),
                  ),
                  disabledColor: AppColors.greySoft,
                  elevation: 0,
                  color: AppColors.blackSoft,
                  onPressed: isLoading
                      ? null
                      : () {
                          if (_formKey.currentState?.validate() ?? false) {
                            loginBloc.add(
                              LoginSubmitted(
                                email: _emailCtrl.text,
                                password: _passwordCtrl.text,
                              ),
                            );
                          }
                        },

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.p64 - 4,
                      vertical: AppSizes.p16 - 1,
                    ),
                    child: Text(
                      isLoading ? l10n.wait : l10n.enter,
                      style: const TextStyle(
                        color: AppColors.onPrimary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
