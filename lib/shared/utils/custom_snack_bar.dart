import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_colors.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/enums/snack_bar_enum.dart';

/// A final [StatefulWidget] that displays a custom, dismissible snack bar
/// at the top of the screen.
///
/// It supports different types (success, error, warning, info) and
/// provides an animated slide-in/slide-out effect.
final class CustomSnackBar extends StatefulWidget {
  /// The message to be displayed in the snack bar.
  final String message;

  /// The type of snack bar, determining its icon and color.
  final SnackBarType type;

  /// The duration for which the snack bar is displayed.
  final Duration duration;

  /// Optional callback invoked when the snack bar is dismissed.
  final VoidCallback? onDismissed;

  /// Creates a constant instance of [CustomSnackBar].
  const CustomSnackBar({
    super.key,
    required this.message,
    this.type = SnackBarType.warning,
    this.duration = const Duration(seconds: 4),
    this.onDismissed,
  });

  /// Displays a [CustomSnackBar] at the top of the current overlay.
  ///
  /// [message]: The text message to show.
  /// [type]: The type of snack bar (defaults to warning).
  /// [duration]: How long the snack bar should be visible (defaults to 4 seconds).
  static void show(
    String message, {
    SnackBarType type = SnackBarType.warning,
    Duration duration = const Duration(seconds: 4),
  }) {
    final OverlayState? overlayState =
        Globals.navigatorKey.currentState?.overlay;
    if (overlayState == null) {
      return; // Cannot show snack bar if overlay is not available.
    }

    late OverlayEntry overlayEntry;
    bool dismissedManually = false;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBar(
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          dismissedManually = true;
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
        },
      ),
    );

    overlayState.insert(overlayEntry);

    // Schedule automatic dismissal after the specified duration.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(duration, () {
        if (!dismissedManually && overlayEntry.mounted) {
          overlayEntry.remove();
        }
      });
    });
  }

  @override
  State<CustomSnackBar> createState() => _CustomSnackBarState();
}

/// The state class for [CustomSnackBar], managing its animation and dismissal.
final class _CustomSnackBarState extends State<CustomSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Key _dismissibleKey;

  // Pre-calculated decorations and styles for performance.
  late final BoxDecoration _boxDecoration;
  late final TextStyle _textStyle;

  @override
  void initState() {
    super.initState();

    _dismissibleKey = UniqueKey();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Starts above the screen
      end: Offset.zero, // Slides to its final position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Initialize decoration and text style based on widget properties.
    _boxDecoration = BoxDecoration(
      color: widget.type.color.withAlpha((0.1 * 255).round()),
      border: Border.all(color: widget.type.color, width: 2),
      borderRadius: BorderRadius.circular(AppSizes.p12),
      boxShadow: const [
        BoxShadow(
          color: AppColors.blackSoft,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );

    _textStyle = const TextStyle(
      color: AppColors.onPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    _controller.forward(); // Start the slide-in animation
  }

  /// Handles the dismissal of the snack bar.
  ///
  /// [triggeredByDismissible]: True if dismissal was initiated by the Dismissible widget.
  void _dismissSnackBar({bool triggeredByDismissible = false}) {
    if (triggeredByDismissible) {
      widget.onDismissed?.call(); // Call the external onDismissed callback
      return;
    }

    // Reverse the animation for slide-out effect, then call onDismissed.
    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismissed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewPadding.top + AppSizes.p16,
      left: AppSizes.p16,
      right: AppSizes.p16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Dismissible(
          key: _dismissibleKey,
          onDismissed: (_) => _dismissSnackBar(triggeredByDismissible: true),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: _boxDecoration,
              child: Row(
                children: [
                  Icon(widget.type.icon, color: widget.type.color),
                  Gap.w12,
                  Expanded(
                    child: Text(
                      widget.message.toUpperCase(),
                      style: _textStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: _dismissSnackBar,
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
