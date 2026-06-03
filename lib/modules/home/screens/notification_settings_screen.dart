import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/components/switch_tile.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/sized_box_widget.dart';

class NotificationSettingsScreen extends StatelessWidget {
  NotificationSettingsScreen({super.key});

  // Section Expansion States
  final RxBool isBuyerExpanded = false.obs;
  final RxBool isSellerExpanded = false.obs;
  final RxBool isSavedContentExpanded = false.obs;
  final RxBool isSocialActivityExpanded = false.obs;
  final RxBool isShowsExpanded = false.obs;

  // --- BUYER States ---
  final RxBool auctionsNotify = true.obs;
  final RxBool followedNotify = true.obs;
  final RxBool offersNotify = true.obs;
  final RxBool purchasesNotify = true.obs;
  final RxBool recommendationsNotify = true.obs;
  final RxBool referralsNotify = true.obs;
  final RxBool rewardsNotify = true.obs;
  final RxBool savedContentNotify = true.obs;
  final RxBool socialNotify = true.obs;

  // --- SELLER States ---
  final RxBool sellerAuctionsNotify = true.obs;
  final RxBool ordersNotify = true.obs;
  final RxBool promoteToolsNotify = true.obs;
  final RxBool promoOffersNotify = true.obs;
  final RxBool guidanceNotify = true.obs;
  final RxBool showsNotify = true.obs;

  //=============SAVED================
  final RxBool savedProducts = true.obs;
  final RxBool savedSearches = true.obs;
  final RxBool savedShows = true.obs;

  //=============SOCIAL ACTIVITY================
  final RxBool chatMentions = true.obs;
  final RxBool directMessage = true.obs;
  final RxBool newFollower = true.obs;

  //=============SHOWS================
  final RxBool newSaves = true.obs;
  final RxBool showtimeReminder = true.obs;

  // --- GENERAL State ---
  final RxBool generalNotify = true.obs;

  void toggleBuyer() => isBuyerExpanded.value = !isBuyerExpanded.value;
  void toggleSeller() => isSellerExpanded.value = !isSellerExpanded.value;
  void toggleSavedContent() => isSavedContentExpanded.value = !isSavedContentExpanded.value;
  void toggleSocialActivity() => isSocialActivityExpanded.value = !isSocialActivityExpanded.value;
  void toggleShows() => isShowsExpanded.value = !isShowsExpanded.value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(text: AppStrings.notificationSettings),
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              //==================== BUYER SECTION =====================
              expandableSection(
                context,
                title: AppStrings.buyerNotifications,
                isExpanded: isBuyerExpanded,
                onExpansionChanged: (val) => toggleBuyer(),
                children:[
                  customSwitch(AppStrings.auctions, Icons.touch_app_outlined, auctionsNotify),
                  customSwitch(AppStrings.followedUsers, Icons.person_pin_outlined, followedNotify),
                  customSwitch(AppStrings.offers, Icons.percent_outlined, offersNotify),
                  customSwitch(AppStrings.purchases, Icons.local_offer_outlined, purchasesNotify),
                  customSwitch(AppStrings.recommendations, Icons.star_border_purple500_rounded, recommendationsNotify),
                  customSwitch(AppStrings.referrals, Icons.people_alt_outlined, referralsNotify),
                  customSwitch(AppStrings.rewardsClub, Icons.extension_outlined, rewardsNotify),
                  customSwitch(AppStrings.savedContent, Icons.contacts_outlined, savedContentNotify),
                  customSwitch(AppStrings.socialActivity, Icons.share_outlined, socialNotify),
                ],
              ),

              SizedBoxWidget(height: 10.h),

              //======================== SELLER SECTION ======================
              expandableSection(
                context,
                title: "Seller Notifications",
                isExpanded: isSellerExpanded,
                onExpansionChanged: (val) => toggleSeller(),
                children:[
                  customSwitch(AppStrings.auctions, Icons.touch_app_outlined, sellerAuctionsNotify),
                  customSwitch(AppStrings.orders, Icons.insert_drive_file_outlined, ordersNotify),
                  customSwitch(AppStrings.promoteTools, Icons.rocket_launch_outlined, promoteToolsNotify),
                  customSwitch(AppStrings.promotionalOffers, Icons.percent_outlined, promoOffersNotify),
                  customSwitch(AppStrings.sellerGuidance, Icons.directions_outlined, guidanceNotify),
                  customSwitch(AppStrings.shows, Icons.broadcast_on_home, showsNotify),
                ],
              ),

              SizedBoxWidget(height: 10.h),
              //======================== SAVED CONTENT ======================
              expandableSection(
                context,
                title: "Saved Content",
                isExpanded: isSavedContentExpanded,
                onExpansionChanged: (val) => toggleSavedContent(),
                children:[
                  customSwitch(AppStrings.savedProducts, Icons.save_alt, savedProducts),
                  customSwitch(AppStrings.savedSearches, Icons.saved_search, savedSearches),
                  customSwitch(AppStrings.savedShows, Icons.slideshow_sharp, savedShows),
                ],
              ),
              SizedBoxWidget(height: 10.h),
              //======================== SOCIAL ACTIVITY ======================
              expandableSection(
                context,
                title: "Social Activity",
                isExpanded: isSocialActivityExpanded,
                onExpansionChanged: (val) => toggleSocialActivity(),
                children:[
                  customSwitch(AppStrings.chatMentions, Icons.wechat_outlined, chatMentions),
                  customSwitch(AppStrings.directMessages, Icons.message_outlined, directMessage),
                  customSwitch(AppStrings.newFollowers, Icons.follow_the_signs_sharp, newFollower),
                ],
              ),
              SizedBoxWidget(height: 10.h),
              //======================== SHOWTIME REMINDER ======================
              expandableSection(
                context,
                title: "Showtime Reminder",
                isExpanded: isShowsExpanded,
                onExpansionChanged: (val) => toggleShows(),
                children:[
                  customSwitch(AppStrings.newSaves, Icons.new_label_outlined, newSaves),
                  customSwitch(AppStrings.showtimeReminders, Icons.notifications_none, showtimeReminder),
                ],
              ),
              SizedBoxWidget(height: 20.h),

              //==================== GENERAL SECTION =====================
              CustomText(
                text: "General Notification",
                fontWeight: FontWeight.w600,
              ),
              SizedBoxWidget(height: 10.h),
              customSwitch(AppStrings.promotional, Icons.star_outline, generalNotify),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to reduce repetitive Obx/SwitchTile code
  Widget customSwitch(String title, IconData icon, RxBool state) {
    return Obx(() => SwitchTile(
      title: title,
      defaultIcon: icon,
      value: state.value,
      onChanged: (val) => state.value = val,
    ));
  }

  Widget expandableSection(
      BuildContext context, {
        required String title,
        required RxBool isExpanded,
        required Function(bool) onExpansionChanged,
        required List<Widget> children,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() => Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: CustomText(
          text: title,
          fontWeight: FontWeight.w600,
        ),
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        initiallyExpanded: isExpanded.value,
        onExpansionChanged: onExpansionChanged,
        trailing: Icon(
          isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: colorScheme.onSurface, // Uses theme dynamic color
        ),
        children:[
          Column(
            children: children
                .map((child) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: child,
            ))
                .toList(),
          ),
        ],
      ),
    ));
  }
}