import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class PaymentShippingDialog extends StatelessWidget {
  const PaymentShippingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color(0xFFDDEEF5), // The light blue background
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Payment & Shipping',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Delivery Method Row
            _buildSelectionTile(
              icon: Icons.local_shipping_rounded,
              label: 'Delivery Method',
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.addressesScreen);
              },
            ),

            const SizedBox(height: 8),

            // Payment Method Row
            _buildSelectionTile(
              icon: Icons.credit_card_rounded,
              label: 'Payment Method',
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.paymentMethodsScreen);
              },
            ),

            const SizedBox(height: 16),

            // Promo Code Field
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFDDEEF5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF1B90B5), width: 2),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Promo Code',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1B90B5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Apply',
                          style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFAAAAAA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const Icon(Icons.edit_outlined, color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }
}