import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/features/login/presentation/ui/auth_background.dart';
import 'package:qribar_cocina/features/login/presentation/ui/login_container.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/language_dropdown.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';

// ...existing imports...

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: LanguageDropdown(),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
