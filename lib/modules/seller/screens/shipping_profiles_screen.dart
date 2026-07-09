import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/modules/seller/controllers/shipping_profiles_controller.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

class ShippingProfilesScreen extends StatelessWidget {
  ShippingProfilesScreen({super.key});

  final controller = Get.put(ShippingProfilesController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.shippingProfiles,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.profiles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_shipping_outlined, size: 64.sp, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                SizedBoxWidget(height: 16.h),
                CustomText(
                  text: 'No Shipping Profiles Found',
                  fontSize: 16,
                  fontColor: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          itemCount: controller.profiles.length,
          separatorBuilder: (_, __) => SizedBoxWidget(height: 15.h),
          itemBuilder: (context, index) {
            final profile = controller.profiles[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.05),
                border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: profile.name, fontWeight: FontWeight.w700, fontSize: 16),
                        SizedBoxWidget(height: 4.h),
                        CustomText(
                          text: '${profile.carrier} - \$${profile.flatRate.toStringAsFixed(2)}',
                          fontSize: 14,
                          fontColor: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      _showDeleteDialog(context, profile.id);
                    },
                  )
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: CustomButton(
          label: 'Create Profile',
          onPressed: () async {
            await Get.toNamed(AppRoutes.createShippingProfileScreen);
            controller.loadProfiles(); // Reload after coming back
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: const Text('Are you sure you want to delete this shipping profile?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteProfile(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
