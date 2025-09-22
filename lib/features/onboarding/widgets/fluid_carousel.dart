import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qribar_cocina/app/enums/app_route_enum.dart';
import 'package:qribar_cocina/app/extensions/app_route_extension.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';
import 'package:qribar_cocina/app/l10n/app_localizations.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_bloc.dart';
import 'package:qribar_cocina/features/authentication/bloc/auth_event.dart';
import 'package:qribar_cocina/features/onboarding/enum/side_enum.dart';
import 'package:qribar_cocina/features/onboarding/widgets/components.dart';
import 'package:qribar_cocina/features/onboarding/widgets/fluid_clipper.dart';
import 'package:qribar_cocina/features/onboarding/widgets/fluid_edge.dart';

class FluidCarousel extends StatefulWidget {
  final List<Widget> children;
  final String email;
  final String password;

  const FluidCarousel({
    super.key,
    required this.children,
    required this.email,
    required this.password,
  });

  @override
  FluidCarouselState createState() => FluidCarouselState();
}

class FluidCarouselState extends State<FluidCarousel>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  int? _dragIndex;
  Offset _dragOffset = Offset.zero;
  double _dragDirection = 0;
  bool _dragCompleted = false;

  FluidEdge edge = FluidEdge(count: 25);
  late Ticker _ticker;
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    _ticker = createTicker(_tick)..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _tick(Duration duration) {
    edge.tick(duration);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final int l = widget.children.length;

    return GestureDetector(
      key: key,
      onPanDown: (details) => _handlePanDown(details, _getSize()),
      onPanUpdate: (details) => _handlePanUpdate(details, _getSize()),
      onPanEnd: (details) => _handlePanEnd(details, _getSize()),
      child: Stack(
        children: <Widget>[
          widget.children[_index % l],
          _dragIndex == null
              ? const SizedBox()
              : ClipPath(
                  clipBehavior: Clip.hardEdge,
                  clipper: FluidClipper(edge, margin: 10.0),
                  child: widget.children[_dragIndex! % l],
                ),
          SunAndMoon(index: _dragIndex ?? 0, isDragComplete: _dragCompleted),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
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
                  onPressed: () {
                    final String email = widget.email;
                    final String password = widget.password;

                    context.read<AuthBloc>().add(
                      AuthEvent.onboardingCompleted(
                        email: email,
                        password: password,
                      ),
                    );
                    context.goTo(AppRouteEnum.cocinaGeneral);
                  },
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      l10n.enter,
                      maxLines: 1,
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Size _getSize() {
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    return box?.size ?? Size.zero;
  }

  void _handlePanDown(DragDownDetails details, Size size) {
    if (_dragIndex != null && _dragCompleted) {
      _index = _dragIndex!;
    }
    _dragIndex = null;
    _dragOffset = details.localPosition;
    _dragCompleted = false;
    _dragDirection = 0;

    edge.farEdgeTension = 0.0;
    edge.edgeTension = 0.01;
    edge.reset();
  }

  void _handlePanUpdate(DragUpdateDetails details, Size size) {
    double dx = details.localPosition.dx - _dragOffset.dx;

    if (!_isSwipeActive(dx)) {
      return;
    }
    if (_isSwipeComplete(dx, size.width)) {
      return;
    }

    if (_dragDirection == -1) {
      dx = size.width + dx;
    }
    edge.applyTouchOffset(Offset(dx, details.localPosition.dy), size);
  }

  bool _isSwipeActive(double dx) {
    // check if a swipe is just starting:
    if (_dragDirection == 0.0 && dx.abs() > 20.0) {
      _dragDirection = dx.sign;

      // Obtener la cantidad total de elementos.
      final int l = widget.children.length;

      // Calcular el próximo índice a partir del swipe.
      final int nextIndex = _index - _dragDirection.toInt();

      // Verificar si el próximo índice es el último o el primero.
      if ((_dragDirection == -1 && _index == l - 1) ||
          (_dragDirection == 1 && _index == 0)) {
        // Si el swipe es hacia adelante y ya estás en el último elemento,
        // o si es hacia atrás y estás en el primero, no permitimos el swipe.
        return false;
      }

      edge.side = _dragDirection == 1.0 ? Side.left : Side.right;
      setState(() {
        _dragIndex = nextIndex;
      });
    }
    return _dragDirection != 0.0;
  }

  bool _isSwipeComplete(double dx, double width) {
    if (_dragDirection == 0.0) {
      return false;
    } // not started
    if (_dragCompleted) {
      return true;
    } // already done

    // check if swipe is just completed:
    double availW = _dragOffset.dx;
    if (_dragDirection == 1) {
      availW = width - availW;
    }
    final double ratio = dx * _dragDirection / availW;

    if (ratio > 0.8 && availW / width > 0.5) {
      _dragCompleted = true;
      edge.farEdgeTension = 0.01;
      edge.edgeTension = 0.0;
      edge.applyTouchOffset();
    }
    return _dragCompleted;
  }

  void _handlePanEnd(DragEndDetails details, Size size) {
    edge.applyTouchOffset();
  }
}
