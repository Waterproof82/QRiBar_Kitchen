import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/onboarding/widgets/fluid_card.dart';
import 'package:qribar_cocina/features/onboarding/widgets/fluid_carousel.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: FluidCarousel(
        email: widget.email,
        password: widget.password,
        children: <Widget>[
          FluidCard(
            color: 'Red',
            altColor: const Color(0xFF4259B2),
            title: l10n.card1Title,
            subtitle: l10n.card1Subtitle,
          ),
          FluidCard(
            color: 'Yellow',
            altColor: const Color(0xFF904E93),
            title: l10n.card2Title,
            subtitle: l10n.card2Subtitle,
          ),
          FluidCard(
            color: 'Blue',
            altColor: const Color(0xFFFFB138),
            title: l10n.card3Title,
            subtitle: l10n.card3Subtitle,
          ),
        ],
      ),
    );
  }
}
