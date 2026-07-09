import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:musaab_adam/core/assets_gen/assets.gen.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/core/widgets/svg_icon.dart';
import '../controllers/start_show_controller.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_inventory_controller.dart';

class StartShowScreen extends GetView<StartShowController> {
  const StartShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Setting up...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white54, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.retry,
                    child: const Text('Retry'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: Get.back,
                    child: const Text('Go Back', style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
            ),
          );
        }

        final call = controller.call;
        if (call == null) return const SizedBox.shrink();

        return StreamCallContainer(
          call: call,
          callConnectOptions: CallConnectOptions(
            camera: TrackOption.enabled(),
            microphone: TrackOption.enabled(),
          ),
          callContentWidgetBuilder: (context, call) {
            return Stack(
              children: [
                _CameraBackground(call: call),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(colorScheme, call),
                        
                        if (!controller.isRehearsal) ...[
                          const Spacer(flex: 1),
                          _buildScheduledCard(context, colorScheme),
                        ],
                        
                        const Spacer(flex: 2),
                        SizedBoxWidget(height: 16.h),
                        CustomButton(
                          label: 'Start Show',
                          backgroundColor: AppColors.orange, // Assuming orange is the yellow/orange brand color
                          textColor: Colors.black, // Dark text on yellow
                          buttonHeight: 50.h,
                          onPressed: controller.goLive,
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, Call call) {
    return Obx(() => Row(
      children: [
        IconButton(
          onPressed: controller.endShow,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        CircleAvatar(
          radius: 18.r,
          backgroundImage: controller.sellerAvatarUrl.value.isNotEmpty
              ? NetworkImage(controller.sellerAvatarUrl.value)
              : null,
          backgroundColor: colorScheme.primary,
          child: controller.sellerAvatarUrl.value.isEmpty
              ? Text(
                  controller.sellerName.value.isNotEmpty
                      ? controller.sellerName.value[0].toUpperCase()
                      : 'S',
                  style: const TextStyle(color: Colors.white),
                )
              : null,
        ),
        SizedBox(width: 8.w),
        CustomText(
          text: controller.sellerName.value.isNotEmpty
              ? controller.sellerName.value
              : 'Seller',
          fontWeight: FontWeight.w700,
          fontColor: Colors.white,
        ),
        const Spacer(),
        if (controller.isRehearsal)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.orange,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: CustomText(
              text: AppStrings.rehearsal,
              fontColor: Colors.white,
              fontSize: 12,
            ),
          ),
      ],
    ));
  }

  Widget _buildScheduledCard(BuildContext context, ColorScheme colorScheme) {
    String scheduledTimeStr = "Upcoming";
    if (controller.scheduledStream?.scheduledAt != null) {
      final local = controller.scheduledStream!.scheduledAt!.toLocal();
      final h = local.hour > 12 ? local.hour - 12 : local.hour == 0 ? 12 : local.hour;
      final m = local.minute.toString().padLeft(2, '0');
      final ampm = local.hour >= 12 ? 'PM' : 'AM';
      // simple format like "Today, 9:30 PM" (if today, else just date)
      scheduledTimeStr = "$h:$m $ampm";
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          CustomText(
            text: 'Show Starts at',
            fontSize: 12,
            fontColor: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
          SizedBoxWidget(height: 4.h),
          CustomText(
            text: scheduledTimeStr, // You can make it say Today if date matches
            fontSize: 24,
            fontColor: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          SizedBoxWidget(height: 12.h),
          CustomText(
            text: 'Go live within 3 days and we\'ll match your first \$150 in sales.',
            fontSize: 12,
            fontColor: Colors.white70,
            textAlignment: TextAlign.center,
          ),
          SizedBoxWidget(height: 24.h),
          
          _buildChecklistItem(
            title: 'Create your show',
            isDone: true,
          ),
          SizedBoxWidget(height: 16.h),
          _buildChecklistItem(
            title: 'Add products to your shop',
            isDone: controller.selectedProduct.value != null,
            onTap: () => _showProductSelectionSheet(context),
          ),
          SizedBoxWidget(height: 16.h),
          _buildChecklistItem(
            title: 'Bring in buyers',
            isDone: true,
          ),
          SizedBoxWidget(height: 16.h),
          _buildChecklistItem(
            title: 'Go live!',
            isDone: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistItem({required String title, required bool isDone, VoidCallback? onTap, bool isLast = false}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? Colors.greenAccent : Colors.white54,
            size: 20.sp,
          ),
          SizedBoxWidget(width: 12.w),
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 14,
              fontColor: isDone ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white54, size: 20.sp),
        ],
      ),
    );
  }
  
  void _showProductSelectionSheet(BuildContext context) {
    if (!Get.isRegistered<SellerInventoryController>()) {
      Get.put(SellerInventoryController());
    }
    final invCtrl = Get.find<SellerInventoryController>();
    invCtrl.loadProducts();

    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            CustomText(
              text: 'Select a Product',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontColor: Colors.black,
            ),
            SizedBoxWidget(height: 16.h),
            Expanded(
              child: Obx(() {
                if (invCtrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                final list = invCtrl.filteredProducts;
                if (list.isEmpty) {
                  return const Center(child: Text("No products found"));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final product = list[index];
                    return ListTile(
                      leading: product.images.isNotEmpty
                          ? Image.network(product.images.first, width: 40.w, height: 40.w, fit: BoxFit.cover)
                          : const Icon(Icons.image),
                      title: Text(product.title),
                      subtitle: Text('\$${product.price}'),
                      onTap: () {
                        controller.setProduct(product);
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      ignoreSafeArea: false,
    );
  }

  Widget _buildSidebar(ColorScheme colorScheme) {
    return Obx(() {
      final items = [
        {
          'icon': Assets.icons.more,
          'label': AppStrings.more,
          'onTap': () {},
        },
        {
          'icon': Assets.icons.boost,
          'label': AppStrings.promote,
          'onTap': () {},
        },
        {
          'icon': Assets.icons.share,
          'label': AppStrings.share,
          'onTap': () {},
        },
        {
          'icon': Assets.icons.camera,
          'label': controller.isCameraEnabled.value ? 'Cam On' : 'Cam Off',
          'onTap': controller.toggleCamera,
        },
      ];

      return Column(
        children: items
            .map((item) => GestureDetector(
                  onTap: item['onTap'] as VoidCallback,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      children: [
                        SvgIcon(
                          icon: item['icon'] as String,
                          height: 30,
                          width: 30,
                          color: Colors.white,
                        ),
                        CustomText(
                          text: item['label'] as String,
                          fontSize: 12,
                          fontColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      );
    });
  }

  Widget _buildChatInput(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dummy joined text
        Row(
          children: [
            CircleAvatar(radius: 12.r, backgroundColor: colorScheme.primary),
            SizedBoxWidget(width: 6.w),
            CustomText(
              text: 'magicalmotleymadeandfound',
              fontWeight: FontWeight.w700,
              fontColor: Colors.white,
              fontSize: 12,
            ),
            SizedBoxWidget(width: 4.w),
            CustomText(
              text: 'joined 👋',
              fontColor: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ],
        ),
        SizedBoxWidget(height: 8.h),
        Container(
          height: 45.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Colors.white38),
          ),
          child: Row(
            children: [
              SizedBoxWidget(width: 12.w),
              Icon(Icons.notes, color: Colors.white, size: 18.sp), // Just an icon placeholder
              SizedBoxWidget(width: 8.w),
              Container(width: 1.w, height: 20.h, color: Colors.white38),
              SizedBoxWidget(width: 8.w),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Say something...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildShopButton(ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
            Positioned(
              right: -6.w,
              top: -6.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: CustomText(text: '23', fontSize: 10, fontColor: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBoxWidget(height: 4.h),
        CustomText(text: 'Shop', fontSize: 12, fontColor: Colors.white, fontWeight: FontWeight.w600),
      ],
    );
  }
}

class _CameraBackground extends StatelessWidget {
  const _CameraBackground({required this.call});

  final Call call;

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: call,
      selector: (state) => state.localParticipant,
      builder: (context, localParticipant) {
        if (localParticipant == null) return Container(color: Colors.black);
        return StreamCallParticipant(
          call: call,
          participant: localParticipant,
          videoFit: VideoFit.cover,
          showSpeakerBorder: false,
          showConnectionQualityIndicator: false,
        );
      },
    );
  }
}
