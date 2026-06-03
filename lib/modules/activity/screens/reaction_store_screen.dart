import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';

class StoreItem {
  final String name;
  final String iconPath;
  final int price;

  StoreItem({required this.name, required this.iconPath, required this.price});
}

class ReactionStoreScreen extends StatelessWidget {
  // Mock data based on your image
  final List<StoreItem> items = [
    StoreItem(name: "Sunburst Dub", iconPath: Assets.images.sun.keyName, price: 5),
    StoreItem(name: "Cotton Candy Dub", iconPath: Assets.images.candy.keyName, price: 500),
    StoreItem(name: "Gimme Givvy", iconPath: Assets.images.giveaway.keyName, price: 500),
    StoreItem(name: "Heat Check", iconPath: Assets.images.heat.keyName, price: 5),
    StoreItem(name: "Chase Card", iconPath: Assets.images.cards.keyName, price: 500),
    StoreItem(name: "Pack Drop", iconPath: Assets.images.drop.keyName, price: 500),
    StoreItem(name: "Gold Coin", iconPath: Assets.images.coinStack.keyName, price: 5),
    StoreItem(name: "Eyed Swipe", iconPath: Assets.images.bow.keyName, price: 500),
    StoreItem(name: "Hot Spot", iconPath: Assets.images.hot.keyName, price: 500),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(),
        title: const Text(
          "Live Reaction Store",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                SvgPicture.asset(Assets.icons.diamond, height: 18,),
                const SizedBox(width: 4),
                const Text("10", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            childAspectRatio: 0.75, // Adjust height-to-width ratio
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemBuilder: (context, index) {
            return ReactionCard(
                item: items[index],
              onTap: (){
                  showPurchaseDialog(context);
              },
            );
          },
        ),
      ),
    );
  }

  void showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Keeps the background clean
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Card
                Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Image.asset(Assets.images.sun.keyName, height: 40, width: 40,),
                      const SizedBox(height: 12),
                      const Text(
                        'Sunburst Dub',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.diamond_outlined, size: 20),
                          SizedBox(width: 4),
                          Text('5', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0091B5),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Text('Buy for 500', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAAAAAA),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Text('Go Back', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReactionCard extends StatelessWidget {
  final StoreItem item;
  final VoidCallback onTap;

  const ReactionCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1), // Light grey background
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // PNG Icon
            Expanded(
              child: Image.asset(
                item.iconPath,
                fit: BoxFit.contain,
                height: 40,
                width: 40,
              ),
            ),
            const SizedBox(height: 3),
            // Name
            Text(
              item.name,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            // Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.diamond_outlined, size: 14),
                const SizedBox(width: 4),
                Text(
                  "${item.price}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}