import 'package:flutter/material.dart';
import 'package:flutter_calendar/gen/colors.gen.dart';
import 'package:flutter_calendar/widgets/text/widget_gradient_text.dart';
import 'package:flutter_component/flutter_component.dart';
import 'package:flutter_component/widgets/widget_animation_click.dart';
import 'package:intl/date_symbol_data_local.dart';

class PageCalendar extends StatefulWidget {
  const PageCalendar({super.key});

  @override
  State<PageCalendar> createState() => _PageCalendarState();
}

class _PageCalendarState extends State<PageCalendar> {
  ValueNotifier<DateTime> dateSelected = ValueNotifier(DateTime.now());

  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Row(children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.menu,
                size: 30,
              ),
            ),
            Expanded(
              child: Center(
                child: WidgetGradientText(
                  "Lịch Việt",
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: ColorName.primary),
                  colors: [
                    ColorName.primary,
                    ColorName.primary.withOpacity(.5),
                  ],
                ),
              ),
            ),
            const Opacity(
              opacity: 0.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(
                  Icons.menu,
                  size: 30,
                ),
              ),
            ),
          ]),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: WidgetCalendar(
                onSelected: (DateTime value) {
                  dateSelected.value = value;
                },
              ),
            ),
          ),
          ValueListenableBuilder<DateTime>(
            valueListenable: dateSelected,
            builder: (context, value, child) {
              final dateTime = LunarCalendar.convertSolar2Lunar(dateSelected.value);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                padding: const EdgeInsets.symmetric(vertical: 24),
                width: context.screenSize().width,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
                child: Column(
                  children: [
                    const Text(
                      "ÂM LỊCH",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Tháng ${dateTime[1]} năm ${dateTime[2]}(${LunarCalendar.getChiYear(dateTime[2])} ${LunarCalendar.getCanYear(dateTime[2])})",
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    FittedBox(
                      child: WidgetGradientText(
                        "${dateTime[0]}",
                        style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900, color: ColorName.primary),
                        colors: [
                          ColorName.primary,
                          ColorName.primary.withOpacity(.8),
                        ],
                      ),
                      // child: Text(
                      //   "${dateTime[0]}",
                      //   style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w900, color: ColorName.primary, height: 1.2),
                      // ),
                    ),
                    Text(
                      "Tháng: ${LunarCalendar.getChiCanMonth(dateTime[1], dateTime[2])}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "Năm: ${LunarCalendar.getChiYear(dateTime[2])} ${LunarCalendar.getCanYear(dateTime[2])}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              );
            },
          )
        ],
      )),
    );
  }
}

class WidgetCalendar extends StatefulWidget {
  const WidgetCalendar({
    Key? key,
    required this.onSelected,
    this.current,
  }) : super(key: key);
  final Function(DateTime value) onSelected;
  final DateTime? current;
  @override
  State<WidgetCalendar> createState() => _WidgetCalendarState();
}

class _WidgetCalendarState extends State<WidgetCalendar> {
  final _lsWeekDay = <String>['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

  late DateTime dateSelected;
  late DateTime currentDateTime;

  PageController controller = PageController(initialPage: 1);

  @override
  void initState() {
    currentDateTime = widget.current ?? DateTime.now();
    dateSelected = widget.current ?? DateTime.now();
    controller.addListener(() {
      if (controller.page == controller.page?.toInt()) {
        debugPrint("xxx: ${controller.page}");
        if (controller.page?.toInt() == 1) return;
        if (controller.page!.toInt() < 1) {
          currentDateTime = DateTime(currentDateTime.year, currentDateTime.month - 1);
          setState(() {});
        } else {
          currentDateTime = DateTime(currentDateTime.year, currentDateTime.month + 1);
          setState(() {});
        }
        controller.jumpToPage(1);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  currentDateTime = DateTime(currentDateTime.year, currentDateTime.month - 1);
                  setState(() {});
                },
                child: _buildIcon(Icons.navigate_before)),
            Text(
              "Tháng ${currentDateTime.month} ${currentDateTime.year}",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            WidgetAnimationClick(
                onTap: () {
                  currentDateTime = DateTime(currentDateTime.year, currentDateTime.month + 1);
                  setState(() {});
                },
                child: _buildIcon(Icons.navigate_next)),
          ],
        ),
        Expanded(
          child: PageView.builder(
            controller: controller,
            itemBuilder: (context, index) {
              if (index == 0) {
                return renderCalendar(DateTime(currentDateTime.year, currentDateTime.month - 1));
              }

              if (index == 2) {
                return renderCalendar(DateTime(currentDateTime.year, currentDateTime.month + 1));
              }

              return renderCalendar(currentDateTime);
            },
          ),
        ),
      ],
    );
  }

  Widget renderCalendar(DateTime dateTime) {
    return CalendarMonthView(
      dateTime: dateTime,
      weekdayTitle: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: List.generate(
            _lsWeekDay.length,
            (index) => Expanded(
              child: Text(
                _lsWeekDay[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      itemCalendarBuilder: (context, DateTime date, int index) {
        return WidgetCalendarItem(
          onTap: () {
            dateSelected = date;
            widget.onSelected.call(date);
            setState(() {});
            // Navigator.of(context).pop();
          },
          day: date,
          colorBackground: index % 2 == 0 ? Colors.white : Colors.grey[100],
          colorSelected: ColorName.primary,
          onValidateSelected: () {
            final checkSelected = dateSelected.onlyDayMonthYear().difference(date.onlyDayMonthYear()).inDays;
            return checkSelected == 0;
          },
        );
      },
    );
  }

  Widget _buildIcon(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16).copyWith(left: 4, right: 4),
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Icon(icon),
    );
  }
}

class WidgetCalendarItem extends StatelessWidget {
  const WidgetCalendarItem({
    Key? key,
    required this.day,
    required this.onValidateSelected,
    this.onTap,
    this.colorSelected,
    this.colorBackground,
    this.textStyle,
  }) : super(key: key);
  final DateTime day;
  final bool Function() onValidateSelected;
  final Function()? onTap;
  final Color? colorSelected;
  final Color? colorBackground;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return WidgetAnimationClick(
      onTap: () {
        onTap?.call();
      },
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: onValidateSelected.call() == true ? colorSelected ?? Colors.red : colorBackground ?? Colors.white,
              border: Border.all(
                  color: onValidateSelected.call() == true
                      ? colorSelected ?? Colors.red
                      : DateTime.now().onlyDayMonthYear().difference(day.onlyDayMonthYear()).inDays == 0
                          ? colorSelected ?? Colors.red
                          : Colors.white)),
          child: Center(
            child: Column(
              children: [
                Text(
                  day.day.toString(),
                  style: (textStyle ?? const TextStyle(fontSize: 16)).copyWith(
                    color: onValidateSelected.call() == true ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "${LunarCalendar.convertSolar2Lunar(day).first}/${LunarCalendar.convertSolar2Lunar(day)[1]}",
                  style:
                      (textStyle ?? const TextStyle(fontSize: 10)).copyWith(color: onValidateSelected.call() == true ? Colors.white : Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
