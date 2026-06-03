import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_choice_chip.dart';

class ShopTab extends StatelessWidget {
  ShopTab({super.key});

  final RxInt shopTabCurrentIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children:[
        SearchBar(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(width: 2, color: colorScheme.primary),
            ),
          ),
          trailing: [Icon(Icons.search, color: colorScheme.primary)],
        ),
        const SizedBox(height: 20),
        Row(
          spacing: 10.w,
          children:[
            _buildTab(AppStrings.all, 0),
            _buildTab(AppStrings.active, 1),
            _buildTab(AppStrings.inactive, 2),
            _buildTab(AppStrings.sold, 3),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() => IndexedStack(
          index: shopTabCurrentIndex.value,
          children:[
            shopProduct(context),
            shopProduct(context),
            shopProduct(context),
            shopProduct(context)
          ],
        ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    return Obx(() => CustomChoiceChip(
      label: label.tr,
      selected: shopTabCurrentIndex.value == index,
      colorChangeable: true,
      borderRadius: 100,
      padding: [10, 4],
      showShadow: true,
      onSelected: (_) => shopTabCurrentIndex.value = index,
    ),
    );
  }

  Widget shopProduct(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children:[
        CachedImageWidget(
          imageUrl: Dummy.product1,
          borderRadius: 20,
          height: 100.h,
          width: 100.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            CustomText(text: "Hand Bag", translate: false, fontColor: colorScheme.onSurface),
            CustomText(text: "One Size", translate: false, fontColor: colorScheme.onSurface.withValues(alpha: 0.7)),
          ],
        )
      ],
    );
  }
}