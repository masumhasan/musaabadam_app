import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/widgets/custom_button.dart';

class BoostScreen extends StatelessWidget {
  const BoostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Boost Seller',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Section: Community Boost
            sectionHeader(Icons.bolt_rounded, "Community Boost"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Learn More",
                    buttonHeight: 45,
                    backgroundColor: const Color(0xFFC4C4C4),
                    textColor: Colors.black,
                    onPressed: () {
                      Get.toNamed(AppRoutes.boostInfoScreen);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: "Boost Show",
                    buttonHeight: 45,
                    backgroundColor: const Color(0xFFFFD5A1),
                    textColor: const Color(0xFFE67E22),
                    onPressed: () {
                      Get.toNamed(AppRoutes.addPaymentMethodScreen);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            boostProgressBar(current: 5, total: 25),

            const SizedBox(height: 40),

            // Section: Send a Tip
            sectionHeader(Icons.front_hand_outlined, "Send a Tip"),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: "Learn More",
                    buttonHeight: 45,
                    backgroundColor: const Color(0xFFC4C4C4),
                    textColor: Colors.black,
                    onPressed: () {
                      Get.toNamed(AppRoutes.tipInfoScreen);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: "Send Tip",
                    buttonHeight: 45,
                    backgroundColor: const Color(0xFFFFD5A1),
                    textColor: const Color(0xFFE67E22),
                    onPressed: () {
                      Get.toNamed(AppRoutes.sendTipScreen);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Header row with Icon and Text
  Widget sectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.black),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Custom Progress Bar with Labels
  Widget boostProgressBar({required double current, required double total}) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 12,
            backgroundColor: const Color(0xFFE0E6ED),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('£${current.toInt()}', style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('£${total.toInt()}', style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}