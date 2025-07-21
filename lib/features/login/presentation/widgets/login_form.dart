import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/const/app_constants.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_bloc.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_event.dart';
import 'package:qribar_cocina/features/biometric/presentation/bloc/biometric_auth_state.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/features/login/presentation/ui/input_decoration.dart';

final class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final l10n = AppLocalizations.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<BiometricAuthBloc, BiometricAuthState>(
          listener: (context, biometricState) {
            biometricState.whenOrNull(
              promptForSetup: (email, password) {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text(l10n.enableBiometricLoginTitle),
                      content: Text(l10n.enableBiometricLoginContent),
                      actions: [
                        TextButton(
                          child: Text(l10n.noThanksButton),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                        TextButton(
                          child: Text(l10n.yesEnableButton),
                          onPressed: () {
                            context.read<BiometricAuthBloc>().add(
                              BiometricAuthEvent.saveCredentialsRequested(
                                email: email,
                                password: password,
                              ),
                            );
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              credentialsSaved: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.biometricsEnabledMessage)),
                );
              },
              biometricLoginSuccess: () {
                context.read<LoginFormBloc>().add(
                  const LoginFormEvent.sessionRestored(),
                );
              },
            );
          },
        ),
        BlocListener<LoginFormBloc, LoginFormState>(
          listenWhen: (previous, current) =>
              previous.loginSuccess != current.loginSuccess ||
              previous.failure != current.failure,
          listener: (context, state) {
            if (state.loginSuccess) {
              context.pushTo(AppRoute.cocinaGeneral);
            }
          },
        ),
      ],
      child: BlocBuilder<LoginFormBloc, LoginFormState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading ||
            previous.failure != current.failure,
        builder: (context, state) {
          final LoginFormBloc bloc = context.read<LoginFormBloc>();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'xxxx@qribar.es',
                      labelText: l10n.email,
                      prefixIcon: Icons.alternate_email_rounded,
                    ),
                    onChanged: (value) => bloc.add(EmailChanged(value)),
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
                    autocorrect: false,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: '*****',
                      labelText: l10n.password,
                      prefixIcon: Icons.lock_clock_outlined,
                    ),
                    onChanged: (value) => bloc.add(PasswordChanged(value)),
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : l10n.passwordError;
                    },
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
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (formKey.currentState?.validate() ?? false) {
                              bloc.add(const LoginSubmitted());
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.p64 - 4,
                        vertical: AppSizes.p16 - 1,
                      ),
                      child: Text(
                        state.isLoading ? l10n.wait : l10n.enter,
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
      ),
    );
  }
}
