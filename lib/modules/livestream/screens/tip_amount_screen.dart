import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';

class TipAmountScreen extends StatelessWidget {
  const TipAmountScreen({super.key});

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
          'Send a Tip',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // The Tip Icon/Logo
            Center(
              child: SvgPicture.asset(Assets.icons.sendTips),
            ),
            const SizedBox(height: 60),

            // Financial Details Section
            _buildPriceRow('Tip amount', '£10', isBold: true),
            const SizedBox(height: 20),
            _buildPaymentRow('Payment'),
            const SizedBox(height: 20),
            _buildPriceRow('Subtotal', '£10', isBold: true),
            const SizedBox(height: 20),
            _buildPriceRow('Payment processing fee', '£0.33'),
            const SizedBox(height: 24),

            // Total Row
            _buildPriceRow('Total', '£10.33', isBold: true, fontSize: 18),

            const Spacer(),

            // Footer Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyCustomButton(
                      text: 'Cancel',
                      onPressed: () {},
                      color: Colors.grey[400], // Example style
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: MyCustomButton(
                      text: 'Send Tip',
                      onPressed: () {},
                      color: Colors.blue[50], // Example style
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

  // Helper for standard text rows
  Widget _buildPriceRow(String label, String amount, {bool isBold = false, double fontSize = 16}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: isBold ? Colors.black : Colors.grey[700],
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // Helper for the row with the edit icon
  Widget _buildPaymentRow(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Icon(Icons.edit, size: 20, color: Colors.black),
      ],
    );
  }
}

// Placeholder for your specific Custom Button component
class MyCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const MyCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}