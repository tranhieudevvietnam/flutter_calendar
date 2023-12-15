import 'package:flutter/material.dart';
import 'package:flutter_calendar/gen/assets.gen.dart';
import 'package:flutter_calendar/gen/colors.gen.dart';
import 'package:flutter_calendar/module/calendar/page_calendar.dart';
import 'package:flutter_calendar/widgets/text/widget_gradient_text.dart';
import 'package:flutter_component/extension/context_extension.dart';

class PageWelCome extends StatefulWidget {
  const PageWelCome({super.key});

  @override
  State<PageWelCome> createState() => _PageWelComeState();
}

class _PageWelComeState extends State<PageWelCome> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animationScale;
  late Animation<double> animationScaleLogo;
  late Animation<double> animationBackground;
  late Animation<double> animationLogo;

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animationScale = Tween<double>(begin: 0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      });
    animationBackground = Tween<double>(begin: 1.5, end: 1.05).animate(animationController);
    animationLogo = Tween<double>(begin: -2.0, end: -0.3).animate(animationController);
    animationScaleLogo = Tween<double>(begin: 0, end: 1.0).animate(animationController);
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(builder: (BuildContext context) => const PageCalendar()),
              (route) => false,
            );
          },
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Transform.scale(
          scale: animationBackground.value,
          child: Assets.images.backgroundWelcome.svg(
            width: context.screenSize().width,
            height: context.screenSize().height,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment(0.0, animationLogo.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: animationScaleLogo.value,
                child: Assets.images.welcome.svg(
                  width: context.screenSize().width / 2,
                  height: context.screenSize().height / 2,
                ),
              ),
              SizedBox(
                height: context.screenSize().width * 0.2,
              ),
              Transform.scale(
                scale: animationScale.value,
                child: WidgetGradientText(
                  "Lịch Việt",
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700, color: ColorName.primary),
                  colors: [
                    ColorName.primary,
                    ColorName.primary.withOpacity(.5),
                  ],
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
