import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class DotIndicator extends StatefulWidget {
  const DotIndicator({
    Key? key,
    required this.currentItem,
    required this.count,
    required this.unselectedColor,
    required this.selectedColor,
    this.size = const Size(12, 12),
    this.unselectedSize = const Size(12, 12),
    this.duration = const Duration(milliseconds: 150),
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.alignment = Alignment.center,
    this.fadeEdges = true,
    this.boxShape = BoxShape.circle,
    this.borderRadius,
    this.onItemClicked,
  }) : assert(
         currentItem >= 0 && currentItem < count,
         'Current item must be within the range of items. Make sure you are using 0-based indexing',
       ),
       assert(
         boxShape != BoxShape.circle || borderRadius == null,
         'Border radius must be provided when using a non-circle shape',
       ),
       super(key: key);

  final int currentItem;

  final int count;

  final Color unselectedColor;

  final Color selectedColor;

  final Size size;

  final Size unselectedSize;

  final Duration duration;

  final EdgeInsets margin;

  final EdgeInsets padding;

  final Alignment alignment;

  final bool fadeEdges;

  final BoxShape boxShape;

  final BorderRadius? borderRadius;

  final void Function(int index)? onItemClicked;

  @override
  State<DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<DotIndicator> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        scrollToCurrentPosition();
      }
    });
  }

  @override
  void didUpdateWidget(covariant DotIndicator oldWidget) {
    if (_scrollController.hasClients) {
      scrollToCurrentPosition();
    }
    super.didUpdateWidget(oldWidget);
  }

  void scrollToCurrentPosition() {
    final widgetOffset = _getOffsetForCurrentPosition();
    _scrollController.animateTo(
      widgetOffset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: <Color>[
            widget.fadeEdges
                ? const Color.fromARGB(0, 255, 255, 255)
                : Colors.orange,
            Colors.orange,
            Colors.orange,
            widget.fadeEdges
                ? const Color.fromARGB(0, 255, 255, 255)
                : Colors.white,
          ],
          tileMode: TileMode.mirror,
          stops: const [0, 0.05, 0.95, 1],
        ).createShader(bounds);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment: widget.alignment,
        height: widget.size.height,
        child: ListView.builder(
          padding: widget.padding,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.count,
          controller: _scrollController,
          shrinkWrap: !_needsScrolling(),
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.antiAlias,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => widget.onItemClicked?.call(index),
              child: AnimatedContainer(
                margin: widget.margin,
                duration: widget.duration,
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius,
                  shape: widget.boxShape,
                  color: index == widget.currentItem
                      ? widget.selectedColor
                      : widget.unselectedColor,
                ),
                width: index == widget.currentItem
                    ? widget.size.width
                    : widget.unselectedSize.width,
                height: index == widget.currentItem
                    ? widget.size.height
                    : widget.unselectedSize.height,
              ),
            );
          },
        ),
      ),
    );
  }

  double _getOffsetForCurrentPosition() {
    final offsetPerPosition =
        _scrollController.position.maxScrollExtent / widget.count;
    final widgetOffset = widget.currentItem * offsetPerPosition;
    return widgetOffset;
  }

  bool _needsScrolling() {
    final viewportWidth = MediaQuery.of(context).size.width;
    final itemWidth =
        widget.unselectedSize.width + widget.margin.left + widget.margin.right;
    final selectedItemWidth =
        widget.size.width + widget.margin.left + widget.margin.right;
    const listViewPadding = 32;
    final shaderPadding = viewportWidth * 0.1;
    return viewportWidth <
        selectedItemWidth +
            (widget.count - 1) * itemWidth +
            listViewPadding +
            shaderPadding;
  }
}
