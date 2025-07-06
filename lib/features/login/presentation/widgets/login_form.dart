import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/const/app_constants.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/features/login/presentation/ui/input_decoration.dart';

/// A final [StatelessWidget] that represents the login form.
/// It handles user input, form validation, and dispatches login events to the [LoginFormBloc].
final class LoginForm extends StatelessWidget {
  /// Creates a constant instance of [LoginForm].
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    // GlobalKey for accessing and validating the FormState.
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocListener<LoginFormBloc, LoginFormState>(
      // Listen only when loginSuccess state changes.
      listenWhen: (previous, current) =>
          previous.loginSuccess != current.loginSuccess,
      listener: (context, state) {
        if (state.loginSuccess) {
          context.goTo(AppRoute.cocinaGeneral);
        }
      },
      child: BlocBuilder<LoginFormBloc, LoginFormState>(
        // Rebuild only when isLoading state changes to optimize performance.
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          // Access the LoginFormBloc instance.
          final LoginFormBloc bloc = context.read<LoginFormBloc>();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p20),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  // Email input field.
                  TextFormField(
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: 'xxxx@qribar.es',
                      labelText: context.l10n.email,
                      prefixIcon: Icons.alternate_email_rounded,
                    ),
                    onChanged: (value) => bloc.add(EmailChanged(value)),
                    validator: (value) {
                      final RegExp regExp = RegExp(AppConstants.emailPattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : context.l10n.emailError;
                    },
                    style: const TextStyle(fontSize: 22),
                  ),
                  Gap.h32,
                  // Password input field.
                  TextFormField(
                    autocorrect: false,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecorations.authInputDecoration(
                      hintText: '*****',
                      labelText: context.l10n.password,
                      prefixIcon: Icons.lock_clock_outlined,
                    ),
                    onChanged: (value) => bloc.add(PasswordChanged(value)),
                    validator: (value) {
                      return (value != null && value.length >= 6)
                          ? null
                          : context.l10n.passwordError;
                    },
                    style: const TextStyle(fontSize: 22),
                  ),
                  Gap.h32,
                  // Login button.
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.p10),
                    ),
                    disabledColor: AppColors.greySoft,
                    elevation: 0,
                    color: AppColors.blackSoft,
                    onPressed: state.isLoading
                        ? null // Disable button when loading
                        : () {
                            // Validate form and dispatch LoginSubmitted event.
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
                        state.isLoading
                            ? context.l10n.wait
                            : context.l10n.enter,
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
