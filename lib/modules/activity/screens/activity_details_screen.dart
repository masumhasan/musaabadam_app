import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/tile_button.dart';

class ActivityDetailsScreen extends StatelessWidget {
  const ActivityDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("Activity", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text("Label Created", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Order placed 13 dec, 2025", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 12,
              backgroundColor: Colors.grey[400],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFF59D)), // Light yellow
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            "This seller has printed the shipping label, which means your order is being prepared for shipment! Once the package is scanned, you'll receive tracking updates to follow its journ...",
            style: TextStyle(color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 20),

          // Primary Actions
          TileButton(
            title: "Message the seller",
            defaultIcon: Icons.chat_bubble_outline,
            onClick: () {
              Get.toNamed(AppRoutes.messageScreen);
            },
          ),
          const SizedBox(height: 12,),
          TileButton(
            title: "Get help with this purchase",
            defaultIcon: Icons.help_outline,
            onClick: () {
              Get.toNamed(AppRoutes.purchaseHelpScreen);
            },
          ),
          const SizedBox(height: 12,),
          TileButton(
            title: "Refer a friend, earn up to £200",
            defaultIcon: Icons.monetization_on_outlined,
            onClick: () {
              Get.toNamed(AppRoutes.rewardPerksScreen);
            },
          ),
          const SizedBox(height: 12,),
          TileButton(
            title: "Track your purchase",
            defaultIcon: Icons.location_on_outlined,
            onClick: () {},
          ),

          const SizedBox(height: 24),
          const Text("adg", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("Order Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),

          // Order Details Table
          _buildDetailRow("Order ID", "587216543"),
          _buildDetailRow("Order date", "10 Dec 2025"),
          _buildDetailRow("Sort by", "Urban echo"),
          _buildDetailRow("QTY", "1"),

          const SizedBox(height: 20),

          // Bottom Actions
          TileButton(
            title: "Receipt & shipping details",
            defaultIcon: Icons.inventory_2_outlined,
            onClick: () {
              Get.toNamed(AppRoutes.receiptDetailsScreen);
            },
          ),
          const SizedBox(height: 12,),
          TileButton(
            title: "Video receipt",
            defaultIcon: Icons.videocam_outlined,
            onClick: () {
              Get.toNamed(AppRoutes.videoReceiptScreen);
            },
          ),
          const SizedBox(height: 10,),
          const Text(
            'About the seller',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Seller Header
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedImageWidget(
                    imageUrl: Dummy.user1,
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Azmir Khan",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF008EAF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn('4.9', 'Rating', isStar: true),
                _buildDivider(),
                _buildStatColumn('1.4 K', 'Followers'),
                _buildDivider(),
                _buildStatColumn('7.4 K', 'Sold'),
                _buildDivider(),
                _buildStatColumn('2d', 'Avg Ship'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hi! I\'m here to make your shopping easy and enjoyable. I offer quality items, fast responses, and honest service. Happy to help anytime!',
            style: TextStyle(color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 20),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Unfollow',
                  buttonHeight: 40,
                  onPressed: () {},
                  backgroundColor: Colors.grey.shade500,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(color: Color(0xFF008EAF), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Feedback Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Seller Feedback (1.9k)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildFeedbackTile(),
          const SizedBox(height: 30),
          // Product Section
          const Text(
            'More from this seller',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildProductRow(),
          const SizedBox(height: 40),
          // Bottom Action
          CustomButton(
            label: AppStrings.viewProfile,
            buttonHeight: 45,
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 15)),
          Text(value, style: const TextStyle(color: Colors.black54, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isStar = false}) {
    return Column(
      children: [
        Row(
          children: [
            if (isStar) const Icon(Icons.star, color: Colors.orange, size: 18),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.white24);
  }

  Widget _buildFeedbackTile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: CachedImageWidget(
            imageUrl: Dummy.user2,
            height: 50,
            width: 50,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Isabela Silveira', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text('Desenvolvedora', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        Row(
          children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 18)),
        )
      ],
    );
  }

  Widget _buildProductRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedImageWidget(
            imageUrl: Dummy.product1,
            height: 120,
            width: 120,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hand Bag', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Text('One Size', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            const Text(
              'Price: £5,000',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}