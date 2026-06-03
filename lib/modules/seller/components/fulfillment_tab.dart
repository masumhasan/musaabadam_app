import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/assets_gen/assets.gen.dart';

class FulfillmentTab extends StatelessWidget {
  const FulfillmentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Optional: removes the back button if this is a root screen
        automaticallyImplyLeading: false,
        title: const Text(
          '0 Shipments',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Add your reset logic here
            },
            child: const Text(
              'Reset',
              style: TextStyle(
                color: Colors.lightBlue, // Matching the light blue color
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8), // Padding from the right edge
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- Center Logo/Image ---
              // Replace 'assets/images/br_logo.png' with your actual image path
              Image.asset(
                Assets.images.appLogo.keyName,
                width: 160.w,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),

              // --- Message Text ---
              const Text(
                "There's nothing here at the moment!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}