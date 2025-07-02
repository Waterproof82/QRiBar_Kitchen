import 'package:flutter/material.dart';
import 'package:qribar_cocina/app/const/app_sizes.dart';
import 'package:qribar_cocina/app/const/globals.dart';
import 'package:qribar_cocina/app/enums/snack_bar_enum.dart';

class CustomSnackBar extends StatefulWidget {
  final String message;
  final SnackBarType type;
  final Duration duration;
  final VoidCallback? onDismissed;

  const CustomSnackBar({super.key, required this.message, this.type = SnackBarType.warning, this.duration = const Duration(seconds: 4), this.onDismissed});

  static void show(String message, {SnackBarType type = SnackBarType.warning, Duration duration = const Duration(seconds: 4)}) {
    final overlayState = Globals.navigatorKey.currentState?.overlay;
    if (overlayState == null) {
      return;
    }

    late OverlayEntry overlayEntry;
    bool dismissedManually = false;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          CustomSnackBar(
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
        ],
      ),
    );

    overlayState.insert(overlayEntry);

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

class _CustomSnackBarState extends State<CustomSnackBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Key _dismissibleKey;

  late final BoxDecoration _boxDecoration;
  late final TextStyle _textStyle;

  @override
  void initState() {
    super.initState();

    _dismissibleKey = UniqueKey();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _offsetAnimation = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _boxDecoration = BoxDecoration(
      color: widget.type.color.withAlpha((0.1 * 255).round()),
      border: Border.all(color: widget.type.color, width: 2),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
    );

    _textStyle = const TextStyle(color: Color.fromARGB(221, 255, 255, 255), fontSize: 16, fontWeight: FontWeight.w500);

    _controller.forward();
  }

  void _dismissSnackBar({bool triggeredByDismissible = false}) {
    if (triggeredByDismissible) {
      widget.onDismissed?.call();
      return;
    }

    _controller.reverse().then((_) {
      if (mounted) {
        widget.onDismissed?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).viewPadding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Dismissible(
          key: _dismissibleKey,
          direction: DismissDirection.horizontal,
          onDismissed: (_) => _dismissSnackBar(triggeredByDismissible: true),
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: _boxDecoration,
              child: Row(
                children: [
                  Icon(widget.type.icon, color: widget.type.color),
                  Gap.w12,
                  Expanded(child: Text(widget.message.toUpperCase(), style: _textStyle)),
                  GestureDetector(
                    onTap: _dismissSnackBar,
                    child: const Icon(Icons.close, size: 20, color: Colors.white),
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
