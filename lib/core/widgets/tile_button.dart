import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_colors.dart';
import 'custom_text.dart';

class TileButton extends StatelessWidget {

  final String title;
  final bool isIconDefault;
  final IconData? defaultIcon;
  final String? svgIconPath;
  final VoidCallback? onClick;
  const TileButton({
    super.key,
    required this.title,
    this.isIconDefault = true,
    this.defaultIcon,
    this.svgIconPath,
    this.onClick
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: ListTile(
          leading: isIconDefault ?
          Icon( defaultIcon ?? Icons.notifications,
          color: AppColors.white,
          )
              :
          SvgPicture.asset( svgIconPath! ),
          title: CustomText(text: title,
            fontColor: AppColors.white,
            fontWeight: FontWeight.w700,
            textAlignment: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            fontSize: 16,
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
