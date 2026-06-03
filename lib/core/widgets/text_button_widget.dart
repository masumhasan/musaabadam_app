import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final double decorationThickness;

  const TextButtonWidget({
    super.key,
    this.onPressed,
    required this.text,
    this.textColor,
    this.fontSize = 18,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.normal,
    this.decoration,
    this.decorationColor,
    this.decorationThickness = 3,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Default to the theme's onSurface color if no color is provided
    final Color effectiveTextColor = textColor ?? colorScheme.onSurface;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(50, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: Alignment.center,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: effectiveTextColor,
          fontStyle: fontStyle,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          decoration: decoration,
          // Fallback to theme color with opacity if decorationColor is null
          decorationColor: decorationColor ?? effectiveTextColor.withValues(alpha: 0.5),
          decorationThickness: decorationThickness.h,
        ),
      ),
    );
  }
}