import 'package:flutter/material.dart';

class TextSpanModel {
  final String text;
  final TextStyle style;
  final List<Color> colors;

  TextSpanModel({
    required this.text,
    required this.colors,
    required this.style,
  });
}

class WidgetGradientRichText extends StatelessWidget {
  const WidgetGradientRichText({
    Key? key,
    required this.listData,
  }) : super(key: key);
  final List<TextSpanModel> listData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RichText(
        text: TextSpan(
            children: List.generate(listData.length, (index) {
      final data = listData[index];
      return TextSpan(
          text: data.text,
          style: data.style.copyWith(
              foreground: data.colors.length > 1
                  ? (Paint()
                    ..shader = LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: data.colors,
                      stops: const [0.55, 0.95],
                    ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height)))
                  : null));
    })));
  }
}
