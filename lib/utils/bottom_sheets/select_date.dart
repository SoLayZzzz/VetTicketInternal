import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePickerController extends GetxController {
  DatePickerController({this.selectedDate});

  DateTime? selectedDate;

  void setDate(DateTime? date) {
    selectedDate = date;
    update();
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({
    super.key,
    this.fontSize = 10,
    this.onSeclectDate,
    this.text = "Date",
    this.height = 60,
    this.width = 160,
    this.allowPastDates = false,
    this.backgroundColor,
    this.selectedDateColor,
    this.borderColor,
    this.borderWidth = 0.5,
    this.assetImage = const AssetImage("images/assets/ic_flag.png"),
    this.showCurrentDateAuto = true,
    this.clearable = true,
    this.minDate,
  });

  final Function(String formarttDate)? onSeclectDate;
  final String? text;
  final double? width, height;
  final bool allowPastDates;
  final Color? backgroundColor;
  final Color? selectedDateColor;
  final Color? borderColor;
  final double borderWidth;
  final AssetImage? assetImage;
  final double? fontSize;
  final bool showCurrentDateAuto;
  final bool clearable;
  final DateTime? minDate;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late final String _controllerTag;
  late final DatePickerController _controller;

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime _maxDate(DateTime a, DateTime b) => a.isAfter(b) ? a : b;

  String _formatYmd(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    _controllerTag = '${widget.hashCode}_${identityHashCode(this)}';
    _controller = Get.put(
      DatePickerController(),
      tag: _controllerTag,
    );
    if (widget.showCurrentDateAuto) {
      final now = DateTime.now();
      _controller.setDate(now);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _formatAndSendDate(now);
      });
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<DatePickerController>(tag: _controllerTag)) {
      Get.delete<DatePickerController>(tag: _controllerTag);
    }
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime currentDate = _dateOnly(now);

    final DateTime resolvedMinDate = widget.minDate != null
        ? _dateOnly(widget.minDate!)
        : (widget.allowPastDates ? DateTime(2000) : currentDate);

    final DateTime firstDate = widget.allowPastDates
        ? resolvedMinDate
        : _maxDate(resolvedMinDate, currentDate);

    final DateTime initialDate = () {
      final candidate = _controller.selectedDate != null
          ? _dateOnly(_controller.selectedDate!)
          : firstDate;
      return candidate.isBefore(firstDate) ? firstDate : candidate;
    }();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.selectedDateColor ?? Colors.black,
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: widget.backgroundColor ?? Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      _controller.setDate(pickedDate);
      _formatAndSendDate(pickedDate);
    }
  }

  void _clearDate() {
    if (!widget.clearable) return;

    _controller.setDate(null);
    if (widget.onSeclectDate != null) {
      widget.onSeclectDate!("");
    }
  }

  void _formatAndSendDate(DateTime date) {
    final formattedDate = _formatYmd(date);

    if (widget.onSeclectDate != null) {
      widget.onSeclectDate!(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectDate,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: widget.borderWidth,
            color: widget.borderColor ?? Colors.black,
          ),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Image(image: widget.assetImage!, width: 25),
            ),
            Expanded(
              child: GetBuilder<DatePickerController>(
                tag: _controllerTag,
                builder: (controller) {
                  final date = controller.selectedDate;
                  return FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      date != null ? _formatYmd(date) : "${widget.text}",
                      style: TextStyle(fontSize: widget.fontSize),
                      maxLines: 1,
                    ),
                  );
                },
              ),
            ),
            GetBuilder<DatePickerController>(
              tag: _controllerTag,
              builder: (controller) {
                if (!widget.clearable || controller.selectedDate == null) {
                  return const SizedBox.shrink();
                }

                return IconButton(
                  icon: const Icon(Icons.close, size: 15),
                  onPressed: _clearDate,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
