import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final String appTitle = Get.arguments ?? "";
  PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(text: appTitle, fontWeight: FontWeight.w700),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CustomText(
          text: "Privacy policy, terms conditions and FAQ",
          translate: false,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}