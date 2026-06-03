import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class PurchaseHelpScreen extends StatelessWidget {
  const PurchaseHelpScreen({super.key});

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
          'Get help with this purchase',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Label Created',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'adg',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Using your custom TileButton widget
            TileButton(
              label: "My order hasn't been delivered",
              onTap: () {
                Get.toNamed(AppRoutes.requestReceivedScreen);
              },
            ),

            const SizedBox(height: 12),
            TileButton(
              label: "Submit a cancellation request",
              onTap: () {
                Get.toNamed(AppRoutes.orderSupportScreen, arguments: "Cancellation request");
              },
            ),
            const SizedBox(height: 12),
            TileButton(
              label: "Update my shipping address",
              onTap: () {
                Get.toNamed(AppRoutes.orderSupportScreen, arguments: "Update shipping address");
              },
            ),
            const SizedBox(height: 12),
            TileButton(
              label: "Request a sales tax refund",
              onTap: () {
                Get.toNamed(AppRoutes.orderSupportScreen, arguments: "Sales tax refund");
              },
            ),
            const SizedBox(height: 12),
            TileButton(
              label: "I was overcharged shipping on my order",
              onTap: () {
                Get.toNamed(AppRoutes.orderSupportScreen, arguments: "Overcharged shipping");
              },
            ),

            // TileButton(
            //   label: "I need help with something else",
            //   onTap: () {
            //
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

/// A placeholder for your custom TileButton widget.
/// Match the styling to the teal buttons in your image.
class TileButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const TileButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF0083A5), // Teal color from image
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}