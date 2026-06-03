import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';

class ChangeCredentialScreen extends StatelessWidget {
  const ChangeCredentialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Capture the boolean argument from Get.arguments
    // Defaulting to false if for some reason the argument is missing
    final bool isPasswordChange = Get.arguments['isPasswordChange'] ?? false;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isPasswordChange ? 'Change Password' : 'Change Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isPasswordChange
                  ? "Enter your new password below."
                  : "Enter your new email address.",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // 2. Conditional UI rendering based on the bool
            if (isPasswordChange) ...[
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ] else ...[
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'New Email Address',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // 3. Action Button
            CustomButton(
                label: isPasswordChange ? 'Update Password' : 'Update Email'
            )
          ],
        ),
      ),
    );
  }
}