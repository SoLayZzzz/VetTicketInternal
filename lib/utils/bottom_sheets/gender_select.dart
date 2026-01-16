import 'package:flutter/material.dart';

class GenderSelectOption extends StatefulWidget {
  const GenderSelectOption({
    super.key,
    this.onTap,
    this.value = 0,
    this.groupValue = 0,
    this.icon = Icons.male,
    this.label = "text",
    this.selectColor = const Color(0xFF2C3E50),
    this.unselectColor = Colors.white,
    this.selectTextColor = Colors.white,
    this.unselectTextColor = Colors.black87,
    this.borderColor = Colors.black26,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.iconSize = 14,
    this.fontSize = 14,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.assetImage = const AssetImage("images/assets/ic_flag.png"),
  });

  final VoidCallback? onTap;
  final int value;
  final int groupValue;
  final IconData icon;
  final String label;
  final Color selectColor;
  final Color unselectColor;
  final Color selectTextColor;
  final Color unselectTextColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final double iconSize;
  final double fontSize;
  final BorderRadius borderRadius;
  final AssetImage? assetImage;

  @override
  State<GenderSelectOption> createState() => _GenderSelectOptionState();
}

class _GenderSelectOptionState extends State<GenderSelectOption> {
  bool get selected => widget.value == widget.groupValue;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: selected ? widget.selectColor : widget.unselectColor,
          borderRadius: widget.borderRadius,
          border: Border.all(
            color: selected ? Colors.transparent : widget.borderColor,
            width: widget.borderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: widget.assetImage!,
              width: 24,
              color:
                  selected ? widget.selectTextColor : widget.unselectTextColor,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: selected
                    ? widget.selectTextColor
                    : widget.unselectTextColor,
                fontSize: widget.fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
