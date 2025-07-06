import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';

/// A final [StatelessWidget] that provides a styled container for login forms.
/// It applies padding, a white background with rounded corners, and a shadow.
final class LoginContainer extends StatelessWidget {
  /// The child widget to be displayed inside the container.
  final Widget _child;

  /// Creates a constant instance of [LoginContainer].
  ///
  /// [child]: The content to be placed within the styled container.
  const LoginContainer({super.key, required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: _cardDecoration(),
        child: _child,
      ),
    );
  }

  /// Builds the [BoxDecoration] for the container, giving it a card-like appearance.
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.onPrimary,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: AppColors.blackSoft2,
          blurRadius: 15,
          offset: Offset(0, 10),
        ),
      ],
    );
  }
}
