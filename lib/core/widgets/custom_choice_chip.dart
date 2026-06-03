import 'package:flutter/material.dart';
import 'custom_text.dart';

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool showShadow;
  final List<double> padding;
  final bool colorChangeable;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final Widget? trailing;
  final Function(bool) onSelected;

  const CustomChoiceChip({
    super.key,
    required this.label,
    this.trailing,
    required this.selected,
    this.padding = const [2, 0],
    this.showShadow = false,
    this.colorChangeable = false,
    this.borderRadius = 0,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on selection and theme
    final Color backgroundColor = selected && colorChangeable
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);

    final Color textColor = selected && colorChangeable
        ? colorScheme.onPrimary
        : colorScheme.primary;

    return ChoiceChip(
      selected: selected,
      showCheckmark: false,
      padding: EdgeInsets.symmetric(horizontal: padding[0], vertical: padding[1]),
      elevation: showShadow ? 4 : 0,
      shadowColor: showShadow ? colorScheme.shadow : Colors.transparent,
      backgroundColor: backgroundColor,
      selectedColor: backgroundColor, // Keep consistent with background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(width: borderWidth, color: borderColor),
      ),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: label,
            fontColor: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          if (trailing != null) ...[
            const SizedBox(width: 4),
            trailing!,
          ]
        ],
      ),
      onSelected: onSelected,
    );
  }
}