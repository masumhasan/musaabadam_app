import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';

class CouponTab extends StatelessWidget {
  const CouponTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. The SVG Icon
              // Replace 'assets/gift_box.svg' with your actual file path
              Image.asset(
                Assets.images.giftBox.keyName,
                height: 200,
              ),
              const SizedBox(height: 40),

              // 2. Main Title
              const Text(
                "You don't have any coupons yet.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Roboto', // Or your custom font
                ),
              ),
              const SizedBox(height: 16),

              // 3. Subtitle / Instructions
              const Text(
                "Join live shows, visit the Gem Store, or complete challenges to earn more",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5, // Line height for better readability
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}