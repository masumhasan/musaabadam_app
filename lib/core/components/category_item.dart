import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/utils/app_colors.dart'; // Ensure this is imported
import '../widgets/cached_image_widget.dart';
import '../widgets/custom_text.dart';

class CategoryItem extends StatefulWidget {
  final String image;
  final String? assetImage;
  final String itemName;
  final double height;
  final double width;
  final double imageWidth;
  final double imageHeight;
  final double marginRight;

  final bool? isSelected;
  final VoidCallback? onTap;

  final Function(bool isSelected)? onSelectionChanged;

  const CategoryItem({
    super.key,
    required this.image,
    this.assetImage,
    required this.itemName,
    this.height = 100,
    this.width = 90,
    this.imageHeight = 60,
    this.imageWidth = 60,
    this.marginRight = 10,
    this.isSelected,
    this.onTap,
    this.onSelectionChanged,
  });

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool _internalSelected = false;

  bool get _isSelected => widget.isSelected ?? _internalSelected;

  void toggleSelection() {
    if (widget.onTap != null) {
      widget.onTap!();
      return;
    }

    setState(() {
      _internalSelected = !_internalSelected;
    });

    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(_internalSelected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    // Define colors based on theme mode
    final Color containerColor = isDark
        ? colorScheme.secondaryContainer
        : AppColors.lightOrange;

    final Color textColor = isDark
        ? colorScheme.onSecondaryContainer
        : AppColors.white;

    return GestureDetector(
      onTap: toggleSelection,
      child: Container(
        height: widget.height.h,
        width: widget.width.w,
        margin: EdgeInsets.only(right: widget.marginRight.w),

        // OUTER BORDER EFFECT
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _isSelected ? colorScheme.primary : Colors.transparent,
            width: 2.w,
          ),
        ),

        child: Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(10.r),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              if( widget.assetImage != null )
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                    widget.assetImage!,
                    width: widget.imageWidth.w,
                    height: widget.imageHeight.h,
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedImageWidget(
                    width: widget.imageWidth.w,
                    height: widget.imageHeight.h,
                    imageUrl: widget.image,
                  ),
                ),
              CustomText(
                text: widget.itemName,
                fontSize: 14,
                fontColor: textColor,
                maxLines: 1,
                overflow: TextOverflow.fade,
                textAlignment: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}