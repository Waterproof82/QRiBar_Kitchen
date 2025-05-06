import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/data/const/app_constants.dart';
import 'package:qribar_cocina/data/const/app_sizes.dart';
import 'package:qribar_cocina/data/extensions/repository_error_extension.dart';
import 'package:qribar_cocina/data/types/repository_error.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/features/login/presentation/ui/input_decoration.dart';
import 'package:qribar_cocina/l10n/l10n.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginFormBloc, LoginFormState>(
      listenWhen: (previous, current) => previous.loginSuccess != current.loginSuccess && current.loginSuccess,
      listener: (context, state) {
        if (state.loginSuccess) {
          Navigator.pushReplacementNamed(context, 'home');
        }
      },
      child: BlocSelector<LoginFormBloc, LoginFormState, bool>(
        selector: (state) => state.isLoading,
        builder: (context, isLoading) {
          final bloc = context.read<LoginFormBloc>();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
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
                      final regExp = RegExp(AppConstants.emailPattern);
                      return regExp.hasMatch(value ?? '') ? null : context.l10n.emailError;
                    },
                    style: TextStyle(fontSize: 22),
                  ),
                  Gap.h32,
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
                      return (value != null && value.length >= 6) ? null : context.l10n.passwordError;
                    },
                    style: TextStyle(fontSize: 22),
                  ),
                  Gap.h32,
                  BlocSelector<LoginFormBloc, LoginFormState, RepositoryError?>(
                    selector: (state) => state.failure,
                    builder: (context, failure) => failure == null
                        ? const SizedBox.shrink()
                        : Text(
                            failure.translateError(context),
                            style: const TextStyle(color: Colors.red),
                          ),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: Colors.black26,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      child: Text(
                        isLoading ? context.l10n.wait : context.l10n.enter,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<LoginFormBloc>().add(const LoginSubmitted());
                            }
                          },
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
