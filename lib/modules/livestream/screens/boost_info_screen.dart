import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:musaab_adam/core/widgets/image_widget.dart';

import '../../../core/assets_gen/assets.gen.dart';

class BoostInfoScreen extends StatelessWidget {
  const BoostInfoScreen({super.key});

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Illustration
            ImageWidget(
                width: double.infinity,
                height: 200,
                imagePath: Assets.images.boostInfoGraphic.keyName
            ),
            const SizedBox(height: 24),

            // Header Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Chip in with other viewers to spotlight this show',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Features List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: const [
                  _FeatureRow(
                    text: 'Join other viewers to reach the contribution goal',
                  ),
                  _FeatureRow(
                    text: 'Once the boost starts, we’ll spotlight the seller across BidsRush for 20 minutes',
                  ),
                  _FeatureRow(
                    text: 'Contributions carry to the seller’s next show if the the goal isn’t met',
                  ),
                  _FeatureRow(
                    text: 'We’ll shout you out in the chat each time you contribute',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;

  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Icon (Using Contrast icon as a placeholder for the logo in your image)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: SvgPicture.asset(Assets.icons.circleCross),
          ),
          const SizedBox(width: 16),
          // Text Content
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}