import 'package:flutter/material.dart';

class TextDefault extends StatelessWidget {
  const TextDefault(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal});

  final String text;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 24, fontWeight: fontWeight),
    );
  }
}

class TextExtraSmall extends StatelessWidget {
  const TextExtraSmall(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal});

  final String text;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 12, fontWeight: fontWeight),
    );
  }
}

class TextMedium extends StatelessWidget {
  const TextMedium(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal});

  final String text;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 20, fontWeight: fontWeight),
    );
  }
}

class TextExtraMedium extends StatelessWidget {
  const TextExtraMedium(
      {super.key,
      required this.text,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal});

  final String text;
  final Color color;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 16, fontWeight: fontWeight),
    );
  }
}

class TextSmall extends StatelessWidget {
  const TextSmall(
      {super.key,
      required this.text,
      this.textAlign,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal});

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: fontWeight,
      ),
    );
  }
}

class TextSmalll extends StatelessWidget {
  const TextSmalll({
    super.key,
    required this.text,
    this.textAlign,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.maxLines = 2, // allow up to 2 lines
    this.overflow = TextOverflow.visible,
    this.softWrap = true,
  });

  final String text;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow overflow;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: fontWeight,
      ),
    );
  }
}
