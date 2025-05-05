import 'package:flutter/material.dart';
import 'package:qribar_cocina/data/const/app_sizes.dart';
import 'package:qribar_cocina/features/login/presentation/ui/auth_background.dart';
import 'package:qribar_cocina/features/login/presentation/ui/login_container.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap.h248,
              LoginContainer(
                child: Column(
                  children: [
                    Gap.h10,
                    Text('Login', style: Theme.of(context).textTheme.headlineMedium),
                    Gap.h24,
                    LoginForm(),
                  ],
                ),
              ),
              Gap.h48
            ],
          ),
        ),
      ),
    );
  }
}
