import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/assets_gen/assets.gen.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final double iconSize;
  final double? height;
  final double? width;
  final BoxShape shape;
  final double borderRadius;
  final double borderWidth;
  final Color borderColor;
  final BoxFit fit;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    this.icon = Icons.person,
    this.iconSize = 70,
    this.height,
    this.width,
    this.shape = BoxShape.rectangle,
    this.borderRadius = 0,
    this.borderWidth = 0,
    this.borderColor = Colors.transparent,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height?.h,
      width: width?.w,
      decoration: BoxDecoration(
        shape: shape,
        borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(borderRadius.r),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      clipBehavior: Clip.antiAlias,
      child: (imageUrl == Dummy.live1 || imageUrl.isEmpty)
          ? Container(
              color: colorScheme.surfaceContainerHighest,
              padding: EdgeInsets.all(12.w),
              child: Image.asset(
                Assets.images.appLogo.keyName,
                fit: fit,
              ),
            )
          : CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(color: Colors.white),
              ),
              errorWidget: (context, url, error) => Center(
                child: Icon(icon, size: iconSize.r, color: Colors.grey),
              ),
            ),
    );
  }

  CachedImageWidget copyWith({
    double? height,
    double? width,
    BoxShape? shape,
    double? borderRadius,
    double? borderWidth,
    Color? borderColor,
    double? iconSize,
  }) {
    return CachedImageWidget(
      imageUrl: imageUrl,
      icon: icon,
      iconSize: iconSize ?? this.iconSize,
      height: height ?? this.height,
      width: width ?? this.width,
      shape: shape ?? this.shape,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      borderColor: borderColor ?? this.borderColor,
    );
  }
}

extension CachedNetworkImageExtension on CachedImageWidget {
  // Shape
  CachedImageWidget get circle => copyWith(shape: BoxShape.circle);
  CachedImageWidget get rectangle => copyWith(shape: BoxShape.rectangle);

  //Size
  CachedImageWidget h(double val) => copyWith(height: val);
  CachedImageWidget w(double val) => copyWith(width: val);

  //common sizes
  CachedImageWidget get h30 => copyWith(height: 30);
  CachedImageWidget get h35 => copyWith(height: 35);
  CachedImageWidget get h40 => copyWith(height: 40);
  CachedImageWidget get h45 => copyWith(height: 45);
  CachedImageWidget get h50 => copyWith(height: 50);
  CachedImageWidget get h55 => copyWith(height: 55);
  CachedImageWidget get h60 => copyWith(height: 60);
  CachedImageWidget get h70 => copyWith(height: 70);
  CachedImageWidget get h80 => copyWith(height: 80);

  CachedImageWidget get w30 => copyWith(width: 30);
  CachedImageWidget get w35 => copyWith(width: 35);
  CachedImageWidget get w40 => copyWith(width: 40);
  CachedImageWidget get w45 => copyWith(width: 45);
  CachedImageWidget get w50 => copyWith(width: 50);
  CachedImageWidget get w55 => copyWith(width: 55);
  CachedImageWidget get w60 => copyWith(width: 60);
  CachedImageWidget get w70 => copyWith(width: 70);
  CachedImageWidget get w80 => copyWith(width: 80);

  CachedImageWidget get s35 => copyWith(height: 35, width: 35, iconSize: 35);
  CachedImageWidget get s40 => copyWith(height: 40, width: 40, iconSize: 40);
  CachedImageWidget get s45 => copyWith(height: 45, width: 45, iconSize: 45);
  CachedImageWidget get s50 => copyWith(height: 50, width: 50, iconSize: 50);
  CachedImageWidget get s55 => copyWith(height: 55, width: 55, iconSize: 55);
  CachedImageWidget get s60 => copyWith(height: 60, width: 60, iconSize: 60);
  CachedImageWidget get s70 => copyWith(height: 70, width: 70, iconSize: 70);
  CachedImageWidget get s80 => copyWith(height: 80, width: 80, iconSize: 80);

  //Border Radius
  CachedImageWidget br(double radius) => copyWith(borderRadius: radius);
  CachedImageWidget get br25 => copyWith(borderRadius: 25);

  // COLOR
  CachedImageWidget bw(double width) => copyWith(borderWidth: width);
  CachedImageWidget bc(Color color) => copyWith(borderColor: color);
}