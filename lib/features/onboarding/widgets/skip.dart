import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';

class Skip extends StatelessWidget {
  const Skip({super.key, required this.visible, required this.onTap});

  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      reverseDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 500),
      child: visible
          ? TextButton(
              onPressed: onTap,
              child: Text(
                context.l10n.skip,
                style: context.theme.textTheme.labelLarge?.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
