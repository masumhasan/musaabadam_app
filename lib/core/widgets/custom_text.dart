import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../assets_gen/fonts.gen.dart';

class CustomText extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final FontStyle fontStyle;
  final Color? fontColor;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextAlign textAlignment;
  final String? fontFamily;
  final bool underline;
  final Color? underlineColor;
  final double underlineWidth;
  final bool translate;

  const CustomText({
    super.key,
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 16,
    this.fontStyle = FontStyle.normal,
    this.fontColor,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.textAlignment = TextAlign.center,
    this.fontFamily = FontFamily.openSans,
    this.underline = false,
    this.underlineColor,
    this.underlineWidth = 1.0,
    this.translate = true,
  });

  @override
  Widget build(BuildContext context) {
    // Theme-aware color: defaults to the current theme's onSurface color
    final Color effectiveColor = fontColor ?? Theme.of(context).colorScheme.onSurface;

    return Text(
      translate ? text.tr : text,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlignment,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        fontStyle: fontStyle,
        color: effectiveColor,
        fontFamily: fontFamily,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        decorationColor: underline ? (underlineColor ?? effectiveColor) : null,
        decorationThickness: underline ? underlineWidth : null,
      ),
    );
  }

  CustomText copyWith({
    FontWeight? fontWeight,
    double? fontSize,
    FontStyle? fontStyle,
    Color? fontColor,
    TextOverflow? overflow,
    int? maxLines,
    TextAlign? textAlignment,
    String? fontFamily,
    bool? underline,
    Color? underlineColor,
    double? underlineWidth,
    bool? translate,
  }) {
    return CustomText(
      text: text,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontStyle: fontStyle ?? this.fontStyle,
      fontColor: fontColor ?? this.fontColor,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textAlignment: textAlignment ?? this.textAlignment,
      fontFamily: fontFamily ?? this.fontFamily,
      underline: underline ?? this.underline,
      underlineColor: underlineColor ?? this.underlineColor,
      underlineWidth: underlineWidth ?? this.underlineWidth,
      translate: translate ?? this.translate,
    );
  }
}

// Extensions for convenient styling
extension CustomTextSizeExt on CustomText {
  CustomText get s12 => copyWith(fontSize: 12);
  CustomText get s14 => copyWith(fontSize: 14);
  CustomText get s16 => copyWith(fontSize: 16);
  CustomText get s18 => copyWith(fontSize: 18);
  CustomText get s20 => copyWith(fontSize: 20);
  CustomText get s24 => copyWith(fontSize: 24);
}

extension CustomTextWeightExt on CustomText {
  CustomText get bold => copyWith(fontWeight: FontWeight.bold);
  CustomText get w600 => copyWith(fontWeight: FontWeight.w600);
  CustomText get w700 => copyWith(fontWeight: FontWeight.w700);
}

extension CustomTextColorExt on CustomText {
  CustomText color(Color color) => copyWith(fontColor: color);
}