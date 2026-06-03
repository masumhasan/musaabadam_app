import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../widgets/custom_text.dart';

class SwitchTile extends StatelessWidget {
  final String title;
  final bool isIconDefault;
  final IconData? defaultIcon;
  final String? svgIconPath;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isIconDefault = true,
    this.defaultIcon,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: isIconDefault
            ? Icon(
          defaultIcon ?? Icons.notifications,
          color: colorScheme.onPrimary,
        )
            : SvgPicture.asset(
          svgIconPath!,
          // Apply color filter to match the icon color
          colorFilter: ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
        ),
        title: CustomText(
          text: title,
          fontColor: colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          textAlignment: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          fontSize: 16,
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          // Using theme-based colors for switch states
          activeColor: colorScheme.onPrimary,
          activeTrackColor: colorScheme.secondaryContainer,
          inactiveThumbColor: colorScheme.surface,
          inactiveTrackColor: colorScheme.surfaceVariant,
        ),
      ),
    );
  }
}