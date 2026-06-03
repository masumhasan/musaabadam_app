import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final FormFieldValidator<String>? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        CustomText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          fontColor: colorScheme.onSurface,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 14.sp,
            ),
            filled: inputTheme.filled,
            fillColor: inputTheme.fillColor,
            contentPadding: inputTheme.contentPadding,
            border: inputTheme.border,
            enabledBorder: inputTheme.enabledBorder,
            focusedBorder: inputTheme.focusedBorder,
            // Added error states from theme
            errorBorder: inputTheme.errorBorder,
            focusedErrorBorder: inputTheme.focusedErrorBorder,
            errorStyle: inputTheme.errorStyle,
          ),
        ),
      ],
    );
  }
}