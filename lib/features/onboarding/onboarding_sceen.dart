import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_bloc.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_event.dart';
import 'package:qribar_cocina/features/onboarding/widgets/dot_indicator.dart';
import 'package:qribar_cocina/features/onboarding/widgets/onboarding_items.dart';
import 'package:qribar_cocina/features/onboarding/widgets/skip.dart';

class OnBoardingScreen extends StatefulWidget {
  final String email;
  final String password;

  const OnBoardingScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final items = context.isPortrait
        ? onboardingPortraitItems(context)
        : onboardingLandscapeItems(context);

    final pageCount = items.length;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        actions: [
          Skip(
            visible: _currentPage < pageCount - 1,
            onTap: () => _controller.animateToPage(
              pageCount - 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: PageView.builder(
                controller: _controller,
                itemCount: pageCount,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (_, index) => items[index],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: kBottomNavigationBarHeight,
              ),
              child: DotIndicator(
                count: pageCount,
                currentItem: _currentPage,
                unselectedColor: Theme.of(context).colorScheme.tertiary,
                selectedColor: Theme.of(context).colorScheme.surface,
                onItemClicked: (index) => _controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(
                    context.width,
                    context.isLandscape
                        ? context.height * 0.15
                        : context.height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _onNextPressed(pageCount),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _currentPage == pageCount - 1
                        ? 'context.l10n.start'
                        : 'context.l10n.next',
                    maxLines: 1,
                    style: context.theme.textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNextPressed(int pageCount) {
    if (_currentPage == pageCount - 1) {
      final String email = widget.email;
      final String password = widget.password;

      context.read<AuthBloc>().add(
        AuthEvent.onboardingCompleted(email: email, password: password),
      );
      context.goTo(AppRoute.cocinaGeneral);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }
  }

  // void _goToLastPage(int pageCount) {
  //   _controller.animateToPage(
  //     pageCount - 1,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.ease,
  //   );
  // }
}
