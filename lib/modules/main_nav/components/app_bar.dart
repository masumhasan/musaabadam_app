import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';

AppBar appBar = AppBar(
  centerTitle: true,
  forceMaterialTransparency: true,
  title: CustomText(text: AppStrings.activity.tr),
);
