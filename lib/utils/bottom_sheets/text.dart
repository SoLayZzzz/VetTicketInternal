import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Text12 extends StatelessWidget {
  const Text12({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.textDecorationStyle,
    this.textOverflow,
    this.fontFamily,
    this.translate = true,
  });

  final String text;
  final bool translate;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? text.tr() : text,
      style: TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: fontWeight,
        overflow: textOverflow,
        decoration: textDecoration,
        decorationStyle: textDecorationStyle,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
      ),
    );
  }
}

class Text14 extends StatelessWidget {
  const Text14({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.textDecorationStyle,
    this.textOverflow,
    this.fontFamily,
    this.translate = true,
  });

  final String text;
  final bool translate;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? text.tr() : text,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: fontWeight,
        overflow: textOverflow,
        decoration: textDecoration,
        decorationStyle: textDecorationStyle,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
      ),
    );
  }
}

class Text16 extends StatelessWidget {
  const Text16({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.textDecorationStyle,
    this.textOverflow,
    this.fontFamily,
    this.translate = true,
  });

  final String text;
  final bool translate;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? text.tr() : text,
      style: TextStyle(
        color: color,
        fontSize: 14,
        fontWeight: fontWeight,
        overflow: textOverflow,
        decoration: textDecoration,
        decorationStyle: textDecorationStyle,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
      ),
    );
  }
}

class Text18 extends StatelessWidget {
  const Text18({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.textDecorationStyle,
    this.textOverflow,
    this.fontFamily,
    this.translate = true,
  });

  final String text;
  final bool translate;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? text.tr() : text,
      style: TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: fontWeight,
        overflow: textOverflow,
        decoration: textDecoration,
        decorationStyle: textDecorationStyle,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
      ),
    );
  }
}

class Text20 extends StatelessWidget {
  const Text20({
    super.key,
    required this.text,
    this.translate = true,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.textDecorationStyle,
    this.textOverflow,
    this.fontFamily,
  });

  final String text;
  final bool translate;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? text.tr() : text,
      style: TextStyle(
        color: color,
        fontSize: 20,
        fontWeight: fontWeight,
        overflow: textOverflow,
        decoration: textDecoration,
        decorationStyle: textDecorationStyle,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
      ),
    );
  }
}

class Text24 extends StatelessWidget {
  const Text24({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.textDecoration,
    this.textDecorationStyle,
    this.textOverflow,
    this.fontFamily,
    this.translate = true,
  });

  final String text;
  final Color? color;
  final bool translate;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final TextDecorationStyle? textDecorationStyle;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Text(
      translate ? text.tr() : text,
      style: TextStyle(
        color: color,
        fontSize: 24,
        fontWeight: fontWeight,
        overflow: textOverflow,
        decoration: textDecoration,
        decorationStyle: textDecorationStyle,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
      ),
    );
  }
}