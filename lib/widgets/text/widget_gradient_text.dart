import 'package:flutter/material.dart';

class WidgetGradientText extends StatelessWidget {
  const WidgetGradientText(
    this.text, {
    Key? key,
    required this.colors,
    this.style,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => (LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
      )).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        overflow: overflow,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
