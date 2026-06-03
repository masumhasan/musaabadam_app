import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';

class GemStoreTab extends StatelessWidget {
  const GemStoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader("Jumbortron", "Live purchase announcement"),
              const SizedBox(height: 15),
              _buildFeaturedCard(),
              const SizedBox(height: 25),
              _buildCategoryIcons(),
              const SizedBox(height: 30),
              _buildHeader("Live Reaction", null),
              const SizedBox(height: 15),
              _buildReactionGrid(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable Header Widget ---
  Widget _buildHeader(String title, String? subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
          ],
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.reactionStoreScreen);
          },
          child: const Text("View All", style: TextStyle(color: Color(0xFF219EBC))),
        ),
      ],
    );
  }

  // --- The Heart Parade Main Card ---
  Widget _buildFeaturedCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage( Assets.images.gemStoreCover.keyName),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 15,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset( Assets.icons.diamond, height: 18),
                    SizedBox(width: 4),
                    Text("10,000", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const Text(
                  "Heart Parade",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: CustomButton(label: "View", buttonHeight: 40,),
          ),
        ],
      ),
    );
  }

  // --- Horizontal Category Row ---
  Widget _buildCategoryIcons() {
    final icons = [ Assets.images.love.keyName,
      Assets.images.clock.keyName,
      Assets.images.smile.keyName,
      Assets.images.fire.keyName];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: icons.map((icon) {
        return Container(
          width: 75,
          height: 75,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F4),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(icon),
        );
      }).toList(),
    );
  }

  // --- Live Reaction Cards ---
  Widget _buildReactionGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _reactionItem("Sunburst Dub", "5", Assets.images.sun.keyName),
        _reactionItem("Cotton Candy Dub", "500", Assets.images.candy.keyName),
        _reactionItem("Gimme Givvy", "500", Assets.images.giveaway.keyName),
      ],
    );
  }

  Widget _reactionItem(String label, String price, String assetPath) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.asset(assetPath, height: 50),
          const SizedBox(height: 10),
          Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.diamond_outlined, size: 14),
              const SizedBox(width: 2),
              Text(price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}