import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../controllers/legal_content_controller.dart';

class PrivacyPolicyScreen extends GetView<LegalContentController> {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final title = (Get.arguments as String?) ?? 'Legal';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(text: title, fontWeight: FontWeight.w700, translate: false),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                const SizedBox(height: 12),
                CustomText(
                  text: 'Failed to load content.',
                  translate: false,
                  fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.retry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.content.value.isEmpty) {
          return Center(
            child: CustomText(
              text: 'No content available.',
              translate: false,
              fontColor: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: SelectableText(
            controller.content.value,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.85),
              fontSize: 14,
              height: 1.7,
            ),
          ),
        );
      }),
    );
  }
}
