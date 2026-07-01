import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/modules/home/controllers/invite_controller.dart';

import '../../../core/assets_gen/assets.gen.dart';

class ReferralTab extends StatelessWidget {
  const ReferralTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.isRegistered<InviteController>() ? Get.find<InviteController>() : Get.put(InviteController());
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image Card
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(Assets.images.referralCover.keyName),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Referrals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 4),
                Text("Invite friends, earn credits to shop"),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Bring a friend, earn up to £200",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),

          // Benefit Cards
          _buildInfoCard(
            iconPath: Assets.icons.makeReferral,
            title: "Make Referrals:",
            desc: "Your friend receives a random credit between £10 to £200",
          ),
          _buildInfoCard(
            iconPath: Assets.icons.getPaid,
            title: "Get Paid:",
            desc: "You get a matching credit when your friend receives their first purchase",
          ),
          _buildInfoCard(
            iconPath: Assets.icons.noLimit,
            title: "No Limit:",
            desc: "The more friends you invite, the more you earn",
          ),

          const SizedBox(height: 30),

          // Referral Code Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() => Text(
                        controller.isLoading.value
                            ? "…"
                            : (controller.referralCode.value.isEmpty ? "—" : controller.referralCode.value),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                ),
                ElevatedButton(
                  onPressed: controller.copyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008EAB),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text("Copy", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Share Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.shareCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE0F2F5),
                foregroundColor: const Color(0xFF008EAB),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Share invite", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({required String iconPath, required String title, required String desc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF008EAB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconPath, colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn), width: 24),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.white, fontSize: 14),
                children: [
                  TextSpan(text: "$title ", style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}