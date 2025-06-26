import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/const/app_constants.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_bloc.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_event.dart';
import 'package:qribar_cocina/features/login/presentation/bloc/login_form_state.dart';
import 'package:qribar_cocina/features/login/presentation/ui/input_decoration.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return BlocListener<LoginFormBloc, LoginFormState>(
      listenWhen: (previous, current) => previous.loginSuccess != current.loginSuccess,
      listener: (context, state) {
        if (state.loginSuccess) {
           Navigator.pushReplacementNamed(context, 'home');
        }
      },
      child: BlocBuilder<LoginFormBloc, LoginFormState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
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
                    style: const TextStyle(fontSize: 22),
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
                    style: const TextStyle(fontSize: 22),
                  ),
                  Gap.h32,
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: Colors.black87,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              bloc.add(const LoginSubmitted());
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      child: Text(
                        state.isLoading ? context.l10n.wait : context.l10n.enter,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
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
