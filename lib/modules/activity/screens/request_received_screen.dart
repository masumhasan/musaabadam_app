import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';

import '../../../core/assets_gen/assets.gen.dart';

class RequestReceivedScreen extends StatelessWidget {
  const RequestReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Request Received',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const Spacer(flex: 1),

            // The Scalloped/Circular Checkmark Icon
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(Assets.icons.doneOrange, colorFilter: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),),
                  const Icon(
                    Icons.check,
                    size: 70,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Header Text
            const Text(
              'Your request has been submitted',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 12),

            // Subtitle Text
            const Text(
              'While sellers are expected to ship within 2 business days, shipped by jan 5',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),

            const Spacer(flex: 4),

            // Bottom "Done" Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0083A8), // Teal/Cyan color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}