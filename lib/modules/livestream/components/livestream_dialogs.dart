import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/routes/app_pages.dart';

void showOptionsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xFFDDE9EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.report_problem_outlined,
                    label: 'Report',
                    onTap: () {},
                  ),
                  const SizedBox(width: 16),
                  _buildOptionButton(
                    icon: Icons.volume_up_outlined,
                    label: 'Sound',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildOptionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF008EAC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void showFollowSellerDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        backgroundColor: const Color(0xFFD9E9F0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24.0,
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Follow This Seller?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              CachedImageWidget(
                imageUrl: Dummy.user1,
                height: 50.h,
                width: 50.w,
                borderRadius: 50,
              ),
              const SizedBox(height: 8),
              const Text(
                'Azmir Khan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: Color(0xFF0083A4),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Not Now',
                        style: TextStyle(
                          color: Color(0xFF0083A4),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0083A4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showBiddingDialog() {
  int secondsRemaining = 11;
  int currentBid = 5;
  bool isMaxBid = true;
  Timer? timer;

  Get.dialog(
    StatefulBuilder(
      builder: (context, setState) {
        // Init timer once
        timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
          if (secondsRemaining > 0) {
            setState(() => secondsRemaining--);
          } else {
            t.cancel();
          }
        });

        return Dialog(
          backgroundColor: const Color(0xFFDDE7EB),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                biddingDialogHeaderSection(secondsRemaining),
                const SizedBox(height: 10),
                Text(
                  AppStrings.enterCustomBid.tr,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                bidSelector(
                  currentBid: currentBid,
                  onDecrement: () => setState(() {
                    if (currentBid > 0) {
                      currentBid--;
                    }
                  }),
                  onIncrement: () => setState(() => currentBid++),
                ),
                const SizedBox(height: 15),
                maxBidToggle(
                  value: isMaxBid,
                  onChanged: (val) => setState(() => isMaxBid = val),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: AppStrings.send.tr,
                  buttonHeight: 50,
                  buttonWidth: double.infinity,
                  onPressed: () {
                    timer?.cancel();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        );
      },
    ),
  ).then((_) => timer?.cancel()); // Ensure timer is destroyed when dialog closes
}

Widget biddingDialogHeaderSection(int seconds) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const SizedBox(width: 40), // Spacer for symmetry
      Text(
        "00:${seconds.toString().padLeft(2, '0')}",
        style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text("£5", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text("Shipping Tax", style: const TextStyle(fontSize: 12)),
        ],
      ),
    ],
  );
}

Widget bidSelector({required int currentBid, required VoidCallback onDecrement, required VoidCallback onIncrement}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.remove, size: 35, color: Colors.black),
        onPressed: onDecrement,
      ),
      Expanded(
        child: Container(
          height: 55,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF008BA3), width: 1.5),
          ),
          child: Text(
            "£$currentBid",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.add, size: 35, color: Colors.black),
        onPressed: onIncrement,
      ),
    ],
  );
}

Widget maxBidToggle({required bool value, required ValueChanged<bool> onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            AppStrings.maxBid.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 5),
          const Icon(Icons.info_outline, size: 20, color: Color(0xFF008BA3)),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF008BA3),
          ),
        ],
      ),
      Text(
        "When on,we’ll automatically place bids for you, up to this price",
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    ],
  );
}

void showClipEditDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: Platform.isIOS
          ? null
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: const Color(0xFFE1EBF1), // Light blue-grey background
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 350, maxHeight: 320),
        child: Stack(
          children: [
            // Network Image centered at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedImageWidget(
                  imageUrl: Dummy.live1,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomButton(
                label: AppStrings.edit,
                buttonHeight: 30,
                onPressed: () {
                  Get.back();
                  Get.toNamed(AppRoutes.clipEditScreen);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
