import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/app/localization/app_language.dart';
import 'package:qribar_cocina/app/localization/widgets/language_dropdown.dart';
import 'package:qribar_cocina/features/login/presentation/ui/auth_background.dart';
import 'package:qribar_cocina/features/login/presentation/ui/login_container.dart';
import 'package:qribar_cocina/features/login/presentation/widgets/login_form.dart';

/// A final [StatelessWidget] representing the login screen of the application.
/// It provides a visual background, a language selection dropdown,
/// and embeds the [LoginForm] within a styled container.
final class LoginScreen extends StatelessWidget {
  /// Creates a constant instance of [LoginScreen].
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: const LanguageDropdown(
                      languages: [AppLanguage.es, AppLanguage.en],
                    ),
                  ),
                ],
              ),
              Gap.h248,
              // Container for the login form with a card-like style.
              LoginContainer(
                child: Column(
                  children: [
                    Gap.h10,
                    // Login title.
                    Text(
                      l10n.login,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap.h24,
                    const LoginForm(),
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
