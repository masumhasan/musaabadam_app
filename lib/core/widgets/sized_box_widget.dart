import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizedBoxWidget extends StatelessWidget {

  final double height;
  final double width;
  final Widget? child;

  const SizedBoxWidget({
    super.key,
    this.height = 0,
    this.width = 0,
    this.child
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: height.h,
      width:width.w,
      child: child ?? SizedBox.shrink(),
    );
  }
}
