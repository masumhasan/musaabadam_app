import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_reward_service.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';

class ChallengesTab extends StatefulWidget {
  const ChallengesTab({super.key});

  @override
  State<ChallengesTab> createState() => _ChallengesTabState();
}

class _CouponSuccessDialog extends StatelessWidget {
  final Map<String, dynamic> coupon;
  const _CouponSuccessDialog({required this.coupon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final code = coupon['code'] ?? '';
    final value = (coupon['discountValue'] as num?)?.toDouble() ?? 0.0;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: const Center(child: CustomText(text: 'Congratulations! 🎉', fontSize: 20, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.images.giftBox.keyName, height: 120.h),
          SizedBoxWidget(height: 16.h),
          CustomText(
            text: 'You have unlocked a £${value.toStringAsFixed(0)} Coupon!',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontColor: colorScheme.onSurface,
          ),
          SizedBoxWidget(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: colorScheme.primary, width: 1),
            ),
            child: CustomText(
              text: code,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontColor: colorScheme.primary,
            ),
          ),
          SizedBoxWidget(height: 12.h),
          CustomText(
            text: 'Use this coupon code at checkout to claim your discount.',
            fontSize: 12,
            fontColor: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Awesome'),
        )
      ],
    );
  }
}

class _ChallengesTabState extends State<ChallengesTab> {
  final ApiRewardService _rewardService = ApiRewardService.instance;
  final Set<String> _claimedChallenges = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkClaimed();
  }

  Future<void> _checkClaimed() async {
    setState(() => _isLoading = true);
    final myRewards = await _rewardService.getMyRewards();
    for (final r in myRewards) {
      final code = r['code']?.toString() ?? '';
      if (code.startsWith('CHALLENGE-')) {
        final parts = code.split('-');
        if (parts.length >= 2) {
          _claimedChallenges.add(parts[1].toLowerCase());
        }
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _claim(String challengeId) async {
    setState(() => _isLoading = true);
    final coupon = await _rewardService.claimChallenge(challengeId);
    setState(() => _isLoading = false);

    if (coupon != null) {
      _claimedChallenges.add(challengeId.toLowerCase());
      showDialog(
        context: context,
        builder: (context) => _CouponSuccessDialog(coupon: coupon),
      );
    } else {
      Get.snackbar('Error', 'Failed to claim challenge. You may have already claimed it.');
    }
    _checkClaimed();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          ChallengeRow(
            iconPath: Assets.images.openTheApp.keyName,
            title: 'Open the app',
            reward: 10,
            progress: 1.0, // Completed
            statusText: '1 of 1 completed',
            isClaimed: _claimedChallenges.contains('open_app'),
            onClaim: () => _claim('open_app'),
          ),
          ChallengeRow(
            iconPath: Assets.images.watchShow.keyName,
            title: 'Watch 1 show for 10+ min',
            reward: 200,
            progress: 1.0, // Completed
            statusText: '1 of 1 show watched',
            isClaimed: _claimedChallenges.contains('watch_show'),
            onClaim: () => _claim('watch_show'),
          ),
          ChallengeRow(
            iconPath: Assets.images.love.keyName,
            title: 'Double-tap 5 times in live show',
            reward: 30,
            progress: 0.0,
            statusText: '0 of 5 shows interacted',
            isClaimed: _claimedChallenges.contains('double_tap'),
            onClaim: () => _claim('double_tap'),
          ),
          ChallengeRow(
            iconPath: Assets.images.bag.keyName,
            title: 'Make 1 purchase',
            reward: 1000,
            progress: 0.0,
            statusText: '0 of 1 purchase made',
            isClaimed: _claimedChallenges.contains('make_purchase'),
            onClaim: () => _claim('make_purchase'),
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
  final bool isClaimed;
  final VoidCallback onClaim;

  const ChallengeRow({
    super.key,
    required this.iconPath,
    required this.title,
    required this.reward,
    required this.progress,
    required this.statusText,
    required this.isClaimed,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(Assets.icons.diamond, width: 14, height: 14),
                        const SizedBox(width: 4),
                        Text(
                          '$reward',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress >= 1.0 ? colorScheme.primary : Colors.grey[400]!,
                          ),
                        ),
                      ),
                    ),
                    if (progress >= 1.0) ...[
                      const SizedBox(width: 12),
                      isClaimed
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const CustomText(
                                text: 'Claimed',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontColor: Colors.grey,
                              ),
                            )
                          : SizedBox(
                              height: 28,
                              child: CustomButton(
                                label: 'Claim',
                                fontSize: 11,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                backgroundColor: colorScheme.primary,
                                textColor: Colors.white,
                                onPressed: onClaim,
                              ),
                            ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  statusText,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}