import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:qribar_cocina/app/enums/assets_enum.dart';

class FluidCard extends StatefulWidget {
  final String color;
  final Color altColor;
  final String title;
  final String subtitle;

  const FluidCard({
    super.key,
    required this.color,
    this.title = '',
    required this.subtitle,
    required this.altColor,
  });

  @override
  State<FluidCard> createState() => _FluidCardState();
}

class _FluidCardState extends State<FluidCard> {
  late Ticker _ticker;

  @override
  void initState() {
    _ticker = Ticker((d) {
      setState(() {});
    })..start();
    super.initState();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final time = DateTime.now().millisecondsSinceEpoch / 2000;
        final scaleX = 1.2 + sin(time) * .05;
        final scaleY = 1.2 + cos(time) * .07;
        final offsetY = 20 + cos(time) * 20;
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Transform.translate(
              offset: Offset(
                -(scaleX - 1) / 2 * width,
                -(scaleY - 1) / 2 * height + offsetY,
              ),
              child: Transform(
                transform: Matrix4.diagonal3Values(scaleX, scaleY, 1),
                child: Image.asset(
                  AssetsEnum.getBgPath(widget.color),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 75.0, bottom: 65.0),
                child: Column(
                  children: <Widget>[
                    //Top Image
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          //  vertical: 50,
                        ),
                        child: Image.asset(
                          AssetsEnum.getIllustrationPath(widget.color),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    //Slider circles
                    SizedBox(
                      height: 14,
                      child: Image.asset(
                        AssetsEnum.getSliderPath(widget.color),
                      ),
                    ),

                    //Bottom content
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18.0,
                          vertical: 40.0,
                        ),
                        child: _buildBottomContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            height: 1.2,
            fontSize: 30.0,
            fontFamily: 'MarcellusSC',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          widget.subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
            fontFamily: 'Lexend',
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
