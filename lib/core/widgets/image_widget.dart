import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageWidget extends StatelessWidget {
  final double height;
  final double width;
  final String imagePath;

  const ImageWidget({
    super.key,
    required this.width,
    required this.height,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {

    return Image.asset(
      imagePath,
      height: height.h,
      width: width.w,
      fit: BoxFit.cover,
    );
  }
}
