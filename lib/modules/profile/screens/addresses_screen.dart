import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/address/address_model.dart';
import '../controllers/addresses_controller.dart';

class AddressesScreen extends GetView<AddressesController> {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
        ),
        title: CustomText(text: 'Addresses', fontWeight: FontWeight.w600, translate: false),
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
                CustomText(text: 'Failed to load addresses.', translate: false, fontColor: colorScheme.onSurface.withValues(alpha: 0.5)),
                const SizedBox(height: 12),
                TextButton(onPressed: controller.retry, child: const Text('Retry')),
              ],
            ),
          );
        }

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          children: [
            _AddressSection(
              title: 'Shipping Addresses',
              icon: Icons.local_shipping_outlined,
              addresses: controller.shippingAddresses,
              type: 'shipping',
              controller: controller,
              colorScheme: colorScheme,
            ),
            SizedBox(height: 24.h),
            _AddressSection(
              title: 'Pickup Addresses',
              icon: Icons.storefront_outlined,
              addresses: controller.pickupAddresses,
              type: 'pickup',
              controller: controller,
              colorScheme: colorScheme,
            ),
            SizedBox(height: 32.h),
          ],
        );
      }),
    );
  }
}

// ── Section ───────────────────────────────────────────────────────────────────

class _AddressSection extends StatelessWidget {
  const _AddressSection({
    required this.title,
    required this.icon,
    required this.addresses,
    required this.type,
    required this.controller,
    required this.colorScheme,
  });

  final String title;
  final IconData icon;
  final List<AddressModel> addresses;
  final String type;
  final AddressesController controller;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.primary),
            SizedBox(width: 8.w),
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                translate: false,
              ),
            ),
            TextButton.icon(
              onPressed: () => controller.addNew(type),
              icon: Icon(Icons.add, size: 18, color: colorScheme.primary),
              label: Text(
                'Add',
                style: TextStyle(color: colorScheme.primary, fontSize: 14.sp),
              ),
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        if (addresses.isEmpty)
          _EmptyState(type: type, colorScheme: colorScheme)
        else
          ...addresses.map((addr) => _AddressCard(
                address: addr,
                controller: controller,
                colorScheme: colorScheme,
              )),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.type, required this.colorScheme});

  final String type;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: CustomText(
        text: type == 'shipping' ? 'No shipping addresses yet.' : 'No pickup addresses yet.',
        translate: false,
        fontColor: colorScheme.onSurface.withValues(alpha: 0.45),
        textAlignment: TextAlign.center,
      ),
    );
  }
}

// ── Address card ──────────────────────────────────────────────────────────────

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.address,
    required this.controller,
    required this.colorScheme,
  });

  final AddressModel address;
  final AddressesController controller;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: address.isDefault
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.onSurface.withValues(alpha: 0.1),
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 22,
            color: address.isDefault ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: address.fullName,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        translate: false,
                      ),
                    ),
                    if (address.isDefault)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          text: 'Default',
                          fontSize: 11.sp,
                          fontColor: colorScheme.primary,
                          translate: false,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 3.h),
                CustomText(
                  text: address.fullAddress,
                  fontSize: 13.sp,
                  fontColor: colorScheme.onSurface.withValues(alpha: 0.55),
                  translate: false,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (address.phone != null && address.phone!.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  CustomText(
                    text: address.phone!,
                    fontSize: 12.sp,
                    fontColor: colorScheme.onSurface.withValues(alpha: 0.45),
                    translate: false,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 6.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => controller.edit(address),
                icon: Icon(Icons.edit_outlined, size: 20, color: colorScheme.primary),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Edit',
              ),
              SizedBox(height: 4.h),
              IconButton(
                onPressed: () => controller.delete(address),
                icon: Icon(Icons.delete_outline_rounded, size: 20, color: colorScheme.error),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                tooltip: 'Delete',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
