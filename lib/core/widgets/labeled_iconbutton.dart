import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class LabeledIconButton extends StatelessWidget {
  final double iconHeight;
  final double iconWidth;
  final double borderWidth;
  final String iconPath;
  final double borderRadius;
  final Color color;
  final Color borderColor;
  final bool isLabelInside;
  final double gap;
  final String text;
  final Color? fontColor;
  final FontWeight fontWeight;
  final double fontSize;
  final List<double> padding;
  final VoidCallback? onClick;

  const LabeledIconButton({
    super.key,
    required this.iconPath,
    this.iconHeight = 20,
    this.iconWidth = 20,
    this.gap = 3,
    required this.text,
    this.borderRadius = 100,
    this.color = AppColors.primaryColor,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.isLabelInside = false,
    this.fontColor,
    this.fontWeight = FontWeight.w700,
    this.fontSize = 14,
    this.padding = const [0,0],
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    //RETURN COLUMN IF LABEL IS NOT INSIDE
    return isLabelInside
        ? GestureDetector(
      onTap: onClick,
          child: Container(
                padding: EdgeInsets.symmetric(horizontal: padding[0], vertical: padding[1]),
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: borderWidth),
                borderRadius: BorderRadius.circular(borderRadius),
                color: color,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: iconHeight.r,
                    width: iconWidth.r,
                    child: SvgPicture.asset(
                      iconPath,
                      height: iconHeight.r,
                      width: iconWidth.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  CustomText(
                    text: text,
                    fontWeight: fontWeight,
                    fontSize: fontSize.sp,
                    fontColor: fontColor ?? AppColors.black,
                  ),
                ],
              ),
            ),
        )
        : GestureDetector(
      onTap: onClick,
          child: Column(
              children: [
                IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: borderWidth),
                      borderRadius: BorderRadius.circular(borderRadius),
                      color: color,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: iconHeight.r,
                        width: iconWidth.r,
                        child: SvgPicture.asset(
                          iconPath,
                          height: iconHeight.r,
                          width: iconWidth.r,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBoxWidget(height: gap.h),
                !text.isEmpty ? CustomText(
                  text: text,
                  fontWeight: fontWeight,
                  fontSize: fontSize.sp,
                  fontColor: fontColor ?? AppColors.black,
                ) : SizedBox.shrink(),
              ],
            ),
        );
  }
}
