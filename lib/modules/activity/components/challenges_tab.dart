import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/assets_gen/assets.gen.dart';

class ChallengesTab extends StatelessWidget {
  const ChallengesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Gem Challenges',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Progress updates can take a few minutes',
              style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12),
            child: Text(
              'Ends in: 07h 13m',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          ChallengeRow(
            iconPath: Assets.images.openTheApp.keyName,
            title: 'Open the app',
            reward: 10,
            progress: 1.0, // Full
            statusText: '0 of 1 show watched',
          ),
          ChallengeRow(
            iconPath: Assets.images.watchShow.keyName,
            title: 'Watch 1 show for 10+...',
            reward: 200,
            progress: 0.0,
            statusText: '0 of 1 show watched',
          ),
          ChallengeRow(
            iconPath: Assets.images.love.keyName,
            title: 'Double-tap 5 times in live show',
            reward: 30,
            progress: 0.0,
            statusText: '0 of 5 shows interacted',
          ),
          ChallengeRow(
            iconPath: Assets.images.bag.keyName,
            title: 'Make 1 purchase',
            reward: 1000,
            progress: 0.0,
            statusText: '0 of 1 purchase made',
          ),
          ChallengeRow(
            iconPath: Assets.images.giveaway.keyName,
            title: 'Enter 3 giveaways',
            reward: 100,
            progress: 0.0,
            statusText: '0 of 3 giveaways entered.',
          ),
        ],
      ),
    );
  }
}

class ChallengeRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final int reward;
  final double progress;
  final String statusText;

  const ChallengeRow({
    super.key,
    required this.iconPath,
    required this.title,
    required this.reward,
    required this.progress,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PNG Icon
          Image.asset(iconPath, width: 50, height: 50),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        // SVG Gem Icon
                        SvgPicture.asset( Assets.icons.diamond, width: 18, height: 18),
                        const SizedBox(width: 4),
                        Text(
                          '$reward',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 12,
                    backgroundColor: Colors.grey[400],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0 ? const Color(0xFFF9F6AA) : Colors.grey[400]!,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusText,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}