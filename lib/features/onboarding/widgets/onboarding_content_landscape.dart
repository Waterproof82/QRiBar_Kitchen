import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qribar_cocina/app/extensions/build_context_extension.dart';

class OnBoardingContentLandscape extends StatelessWidget {
  const OnBoardingContentLandscape({
    required String asset,
    AlignmentGeometry assetAlign = Alignment.center,
    required String title,
    required String content,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(8.0),
    super.key,
  }) : _asset = asset,
       _assetAlign = assetAlign,
       _title = title,
       _content = content,
       _contentPadding = contentPadding;

  final String _asset;
  final AlignmentGeometry _assetAlign;
  final String _title;
  final String _content;
  final EdgeInsetsGeometry _contentPadding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: _assetAlign,
          child: SvgPicture.asset(
            _asset,
            fit: BoxFit.scaleDown,
            width: context.width * .2,
          ),
        ),
        const SizedBox(height: 24.0),
        Container(
          width: context.width * .6,
          padding: _contentPadding,
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _content,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: context.theme.textTheme.labelLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
