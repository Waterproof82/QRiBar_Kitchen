import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/features/login/presentation/ui/auth_background.dart';
import 'package:qribar_cocina/features/login/presentation/ui/login_container.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';
import 'package:qribar_cocina/shared/utils/language_dropdown.dart';

/// A final [StatelessWidget] representing the login screen of the application.
/// It provides a visual background, a language selection dropdown,
/// and embeds the [LoginForm] within a styled container.
final class LoginScreen extends StatelessWidget {
  /// Creates a constant instance of [LoginScreen].
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // The background for the authentication screen.
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Row containing the language dropdown, aligned to the end.
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [Flexible(child: LanguageDropdown())],
              ),
              Gap.h248,
              // Container for the login form with a card-like style.
              LoginContainer(
                // Use const for LoginContainer
                child: Column(
                  children: [
                    Gap.h10,
                    // Login title.
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap.h24,
                    LoginForm(),
                  ],
                ),
              ),
              Gap.h48, // Vertical spacing
            ],
          ),
        ),
      ),
    );
  }
}
