import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../controllers/faq_controller.dart';

class SellerFaqScreen<T extends FaqController> extends GetView<T> {
  const SellerFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.faq,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.faqs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadFaqs,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            itemCount: controller.faqs.length,
            itemBuilder: (context, index) {
              final item = controller.faqs[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildExpansionTile(item['question']!, item['answer']!, colorScheme),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildExpansionTile(String question, String answer, ColorScheme colorScheme) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent, // Removes border between tiles
        expansionTileTheme: ExpansionTileThemeData(
          backgroundColor: colorScheme.primary, // Background when expanded
          collapsedBackgroundColor: colorScheme.primary, // Background when collapsed
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: ExpansionTile(
          title: CustomText(
            text: question,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontColor: Colors.white,
            textAlignment: TextAlign.start,
            overflow: TextOverflow.visible,
          ),
          children:[
            Container(
              color: colorScheme.surface, // Background for the answer text
              padding: EdgeInsets.all(16.w),
              child: CustomText(
                text: answer,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontColor: colorScheme.onSurface,
                textAlignment: TextAlign.start,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}