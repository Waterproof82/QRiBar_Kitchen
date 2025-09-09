import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/enums/svg_enum.dart';
import 'package:qribar_cocina/app/extensions/l10n.dart';
import 'package:qribar_cocina/features/onboarding/widgets/onboarding_content.dart';
import 'package:qribar_cocina/features/onboarding/widgets/onboarding_content_landscape.dart';

List<Widget> onboardingPortraitItems(BuildContext context) => <Widget>[
  OnBoardingContent(
    asset: SvgEnum.logo.path,
    assetAlign: Alignment.centerRight,
    title: 'context.l10n.welcomeToGarrapataAlert',
    content: 'context.l10n.discoverEssentialInformation',
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  ),
  OnBoardingContent(
    asset: SvgEnum.logo.path,
    title: 'context.l10n.informPreventProtect',
    content: 'context.l10n.weTeachYou',
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  ),
  OnBoardingContent(
    asset: SvgEnum.logo.path,
    title: 'context.l10n.joinForCompleteProtection',
    content: 'context.l10n.whenJoinYouConvertInto',
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  ),
];

List<Widget> onboardingLandscapeItems(BuildContext context) => <Widget>[
  OnBoardingContentLandscape(
    asset: SvgEnum.logo.path,
    assetAlign: Alignment.centerRight,
    title: 'context.l10n.welcomeToGarrapataAlert',
    content: 'context.l10n.discoverEssentialInformation',
    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
  ),
  OnBoardingContentLandscape(
    asset: SvgEnum.logo.path,
    title: 'context.l10n.informPreventProtect',
    content: 'context.l10n.weTeachYou',
    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
  ),
  OnBoardingContentLandscape(
    asset: SvgEnum.logo.path,
    title: 'context.l10n.joinForCompleteProtection',
    content: 'context.l10n.whenJoinYouConvertInto',
    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
  ),
];
