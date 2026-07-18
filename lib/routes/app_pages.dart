import 'package:get/get.dart';
import 'package:musaab_adam/modules/activity/screens/friends_screen.dart';
import 'package:musaab_adam/modules/activity/screens/purchase_help_screen.dart';
import 'package:musaab_adam/modules/activity/screens/reaction_store_screen.dart';
import 'package:musaab_adam/modules/activity/screens/receipt_details_screen.dart';
import 'package:musaab_adam/modules/activity/screens/request_received_screen.dart';
import 'package:musaab_adam/modules/activity/screens/rewards_perks_screen.dart';
import 'package:musaab_adam/modules/activity/screens/video_reciept_screen.dart';
import 'package:musaab_adam/modules/livestream/screens/boost_info_screen.dart';
import 'package:musaab_adam/modules/livestream/screens/edit_snap_screen.dart';
import 'package:musaab_adam/modules/home/screens/message_screen.dart';
import 'package:musaab_adam/modules/home/screens/search_screen.dart';
import 'package:musaab_adam/modules/home/bindings/search_binding.dart';
import 'package:musaab_adam/modules/home/bindings/message_binding.dart';
import 'package:musaab_adam/modules/livestream/screens/story_screen.dart';
import 'package:musaab_adam/modules/livestream/screens/tip_amount_screen.dart';
import 'package:musaab_adam/modules/livestream/screens/tip_info_screen.dart';
import 'package:musaab_adam/modules/main_nav/bindings/main_nav_binding.dart';
import 'package:musaab_adam/modules/profile/bindings/change_credential_binding.dart';
import 'package:musaab_adam/modules/profile/bindings/profile_binding.dart';
import 'package:musaab_adam/modules/profile/screens/change_credentials_screen.dart';
import 'package:musaab_adam/modules/profile/screens/preferences_screen.dart';
import 'package:musaab_adam/modules/profile/bindings/legal_content_binding.dart';
import 'package:musaab_adam/modules/profile/screens/privacy_policy_screen.dart';
import 'package:musaab_adam/modules/profile/screens/sales_tax_exemption.dart';
import 'package:musaab_adam/modules/profile/screens/user_reports_screen.dart';
import 'package:musaab_adam/modules/seller/screens/create_shipping_profile_screen.dart';
import 'package:musaab_adam/modules/seller/screens/fullfillment_screen.dart';
import 'package:musaab_adam/modules/seller/screens/invite_seller_screen.dart';
import 'package:musaab_adam/modules/seller/screens/offers_screen.dart';
import 'package:musaab_adam/modules/seller/screens/permissions_screen.dart';
import 'package:musaab_adam/modules/seller/screens/promote_tools_screen.dart';
import 'package:musaab_adam/modules/seller/screens/shipping_profiles_screen.dart';
import 'package:musaab_adam/modules/seller/bindings/start_show_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/start_auction_binding.dart';
import 'package:musaab_adam/modules/seller/screens/start_show_screen.dart';
import 'package:musaab_adam/modules/seller/screens/start_auction_screen.dart';
import 'package:musaab_adam/modules/seller/screens/end_show_insights_screen.dart';
import 'package:musaab_adam/modules/seller/bindings/end_show_insights_binding.dart';
import 'package:musaab_adam/modules/seller/screens/rehearsal_screen.dart';
import 'package:musaab_adam/modules/seller/bindings/rehearsal_binding.dart';
import 'package:musaab_adam/modules/seller/screens/schedule_live_show.dart';
import 'package:musaab_adam/modules/seller/screens/seller_inventory_screen.dart';
import 'package:musaab_adam/modules/seller/screens/seller_order_screen.dart';
import 'package:musaab_adam/modules/seller/screens/seller_payout_screen.dart';
import 'package:musaab_adam/modules/seller/screens/payout_history_screen.dart';
import 'package:musaab_adam/modules/payments/bindings/checkout_binding.dart';
import 'package:musaab_adam/modules/payments/bindings/wallet_binding.dart';
import 'package:musaab_adam/modules/payments/bindings/payment_methods_binding.dart';
import 'package:musaab_adam/modules/payments/screens/payment_methods_screen.dart';
import 'package:musaab_adam/modules/payments/screens/checkout_screen.dart';
import 'package:musaab_adam/modules/payments/screens/wallet_screen.dart';
import 'package:musaab_adam/modules/shipping/bindings/order_tracking_binding.dart';
import 'package:musaab_adam/modules/shipping/screens/order_tracking_screen.dart';
import 'package:musaab_adam/modules/seller/bindings/seller_orders_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/fulfillment_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/seller_payout_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/payout_history_binding.dart';
import 'package:musaab_adam/modules/seller/screens/seller_tool_screen.dart';
import 'package:musaab_adam/modules/seller/screens/shipping_screen.dart';
import 'package:musaab_adam/modules/seller/screens/shows_screen.dart';
import 'package:musaab_adam/modules/seller/screens/tips_screen.dart';
import 'package:musaab_adam/modules/profile/bindings/update_profile_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/create_product_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/schedule_show_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/seller_inventory_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/seller_analytics_binding.dart';
import 'package:musaab_adam/modules/seller/screens/seller_analytics_screen.dart';
import 'package:musaab_adam/modules/seller/bindings/shows_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/seller_tips_binding.dart';
import 'package:musaab_adam/modules/seller/bindings/premier_shop_binding.dart';
import 'package:musaab_adam/modules/seller/screens/premier_shop_screen.dart';
import 'package:musaab_adam/modules/seller_verification/bindings/seller_verification_binding.dart';

import 'package:musaab_adam/modules/seller_verification/bindings/faq_binding.dart';
import 'package:musaab_adam/modules/seller_verification/controllers/faq_controller.dart';
import 'package:musaab_adam/modules/seller_verification/screens/ready_to_earn_screen.dart';
import 'package:musaab_adam/modules/seller_verification/screens/seller_address_screen.dart';
import 'package:musaab_adam/modules/seller_verification/screens/seller_average_earning.dart';
import 'package:musaab_adam/modules/seller_verification/screens/seller_category_screen.dart';
import 'package:musaab_adam/modules/seller_verification/screens/seller_faq_screen.dart';
import 'package:musaab_adam/modules/seller_verification/screens/seller_subcategory_screen.dart';
import 'package:musaab_adam/modules/seller_verification/screens/seller_type_screen.dart';
import 'package:musaab_adam/modules/seller_verification/screens/seller_kyc_screen.dart';

import '../modules/activity/screens/activity_details_screen.dart';
import '../modules/auth/screens/check_email_screen.dart';
import '../modules/auth/screens/forgot_password_screen.dart';
import '../modules/auth/screens/new_password_screen.dart';
import '../modules/auth/screens/profile_setup_screen.dart';
import '../modules/auth/screens/signin_screen.dart';
import '../modules/auth/screens/signup_screen.dart';
import '../modules/profile/screens/account_health_screen.dart';
import '../modules/profile/screens/my_rewards_screen.dart';
import '../modules/profile/screens/update_profile_screen.dart';
import '../modules/profile/bindings/addresses_binding.dart';
import '../modules/profile/bindings/address_form_binding.dart';
import '../modules/profile/screens/new_address_screen.dart';
import '../modules/home/screens/add_payment_method_screen.dart';
import '../modules/profile/screens/addresses_screen.dart';
import '../modules/livestream/screens/boost_screen.dart';
import '../modules/seller/screens/create_quality_listing.dart';
import '../screens/contact_us_screens/account_information_update_screen/account_information_update_screen.dart';
import '../screens/contact_us_screens/account_issues_screen/account_issues_screen.dart';
import '../modules/profile/screens/contact_us_screen.dart';
import '../screens/contact_us_screens/general_issues_screen/general_issues_screen.dart';
import '../screens/contact_us_screens/payout_screen/payout_screen.dart';
import '../modules/auth/screens/account_verified_screen.dart';
import '../modules/auth/screens/link_expired_screen.dart';
import '../modules/auth/screens/verify_email_screen.dart';
import '../screens/error_screen/error_screen.dart';
import '../modules/home/screens/archive_screen.dart';
import '../modules/home/screens/inbox_screen.dart';
import '../modules/home/screens/invite_screen.dart';
import '../modules/home/bindings/invite_binding.dart';
import '../modules/home/screens/wishlist_screen.dart';
import '../modules/home/bindings/wishlist_binding.dart';
import '../modules/home/screens/message_request_screen.dart';
import '../modules/home/screens/notification_screen.dart';
import '../modules/livestream/bindings/livestream_binding.dart';
import '../modules/livestream/bindings/replay_binding.dart';
import '../modules/livestream/bindings/past_shows_binding.dart';
import '../modules/livestream/screens/livestream_screen.dart';
import '../modules/livestream/screens/replay_screen.dart';
import '../modules/livestream/screens/past_shows_screen.dart';
import '../modules/main_nav/screens/main_nav_screen.dart';
import '../modules/home/screens/notification_settings_screen.dart';
import '../modules/profile/screens/order_support_screen.dart';
import '../modules/profile/bindings/other_user_profile_binding.dart';
import '../modules/profile/screens/other_user_profile_screen.dart';
import '../modules/profile/screens/profile_screen.dart';
import '../modules/livestream/screens/send_tip_screen.dart';

part 'app_routes.dart';

class AppPages {
  static final pages = [

    //===================AUTH====================
    GetPage(name: AppRoutes.signInScreen, page: () => SignInScreen()),
    GetPage(name: AppRoutes.signUpScreen, page: () => SignUpScreen()),
    GetPage(name: AppRoutes.profileSetupScreen, page: () => ProfileSetupScreen()),
    GetPage(name: AppRoutes.forgotPasswordScreen, page: () => ForgotPasswordScreen()),
    GetPage(name: AppRoutes.checkEmailScreen, page: () => CheckEmailScreen()),
    GetPage(name: AppRoutes.newPasswordScreen, page: () => NewPasswordScreen()),
    GetPage(name: AppRoutes.verifyEmailScreen, page: () => VerifyEmailScreen()),
    GetPage(name: AppRoutes.linkExpiredScreen, page: () => LinkExpiredScreen()),
    GetPage(name: AppRoutes.accountVerifiedScreen, page: () => AccountVerifiedScreen()),

    //===================MAIN====================
    GetPage(name: AppRoutes.mainScreen, page: () => MainNavScreen(), binding: MainNavBinding()),

    //===================ACTIVITY====================
    GetPage(name: AppRoutes.friendsScreen, page: () => FriendsScreen()),
    GetPage(name: AppRoutes.activityDetailsScreen, page: () => ActivityDetailsScreen()),
    GetPage(name: AppRoutes.purchaseHelpScreen, page: () => PurchaseHelpScreen()),
    GetPage(name: AppRoutes.requestReceivedScreen, page: () => RequestReceivedScreen()),
    GetPage(name: AppRoutes.rewardPerksScreen, page: () => RewardsPerksScreen()),
    GetPage(name: AppRoutes.reactionStoreScreen, page: () => ReactionStoreScreen()),
    GetPage(name: AppRoutes.receiptDetailsScreen, page: () => ReceiptDetailsScreen()),
    GetPage(name: AppRoutes.videoReceiptScreen, page: () => VideoReceiptScreen()),
    //===================MESSAGING====================
    GetPage(name: AppRoutes.inboxScreen, page: () => InboxScreen()),
    GetPage(name: AppRoutes.messageScreen, page: () => MessageScreen(), binding: MessageBinding()),
    GetPage(name: AppRoutes.messageRequestScreen, page: () => MessageRequestScreen()),
    GetPage(name: AppRoutes.archiveScreen, page: () => ArchiveScreen()),

    //===================NOTIFICATIONS====================
    GetPage(name: AppRoutes.notificationScreen, page: () => NotificationScreen()),
    GetPage(name: AppRoutes.notificationSettingsScreen, page: () => NotificationSettingsScreen()),

    //===================FEATURES====================
    GetPage(name: AppRoutes.searchScreen, page: () => const SearchScreen(), binding: SearchBinding()),
    GetPage(name: AppRoutes.inviteScreen, page: () => const InviteScreen(), binding: InviteBinding()),
    GetPage(name: AppRoutes.wishlistScreen, page: () => const WishlistScreen(), binding: WishlistBinding()),
    GetPage(name: AppRoutes.livestreamScreen, page: () => LiveStreamScreen(), binding: LivestreamBinding()),
    GetPage(name: AppRoutes.replayScreen, page: () => const ReplayScreen(), binding: ReplayBinding()),
    GetPage(name: AppRoutes.pastShowsScreen, page: () => const PastShowsScreen(), binding: PastShowsBinding()),
    GetPage(name: AppRoutes.boostScreen, page: () => BoostScreen()),
    GetPage(name: AppRoutes.boostInfoScreen, page: () => BoostInfoScreen()),
    GetPage(name: AppRoutes.snapEditScreen, page: () => const EditSnapScreen()),
    GetPage(name: AppRoutes.storyScreen, page: () => StoryScreen()),

    //===================PAYMENTS & REWARDS====================
    GetPage(name: AppRoutes.sendTipScreen, page: () => SendTipScreen()),
    GetPage(name: AppRoutes.tipInfoScreen, page: () => TipInfoScreen()),
    GetPage(name: AppRoutes.tipAmountScreen, page: () => TipAmountScreen()),
    GetPage(name: AppRoutes.addPaymentMethodScreen, page: () => AddPaymentMethodScreen()),
    GetPage(
      name: AppRoutes.paymentMethodsScreen,
      page: () => const PaymentMethodsScreen(),
      binding: PaymentMethodsBinding(),
    ),
    GetPage(name: AppRoutes.payoutScreen, page: () => PayoutScreen()),
    GetPage(name: AppRoutes.myRewardsScreen, page: () => MyRewardsScreen()),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutScreen(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: AppRoutes.orderTrackingScreen,
      page: () => const OrderTrackingScreen(),
      binding: OrderTrackingBinding(),
    ),

    //===================PROFILE====================
    GetPage(name: AppRoutes.profileScreen, page: () => ProfileScreen(), binding: ProfileBinding()),
    GetPage(
      name: AppRoutes.otherUserProfileScreen,
      page: () => OtherUserProfileScreen(userId: Get.arguments as String),
      binding: OtherUserProfileBinding(),
    ),
    GetPage(name: AppRoutes.updateProfileScreen, page: () => const UpdateProfileScreen(), binding: UpdateProfileBinding()),
    GetPage(name: AppRoutes.accountHealthScreen, page: () => AccountHealthScreen()),
    GetPage(name: AppRoutes.preferencesScreen, page: () => PreferencesScreen()),
    GetPage(name: AppRoutes.accountInformationUpdateScreen, page: () => AccountInformationUpdateScreen()),
    GetPage(name: AppRoutes.salesTaxExemptionScreen, page: () => SalesTaxExemptionScreen()),
    GetPage(name: AppRoutes.userReports, page: () => UserReportsScreen()),
    GetPage(name: AppRoutes.changeCredential, page: () => const ChangeCredentialScreen(), binding: ChangeCredentialBinding()),

    //===================ADDRESS====================
    GetPage(name: AppRoutes.newAddressScreen, page: () => const NewAddressScreen(), binding: AddressFormBinding()),
    GetPage(name: AppRoutes.addressesScreen, page: () => const AddressesScreen(), binding: AddressesBinding()),

    //===================SUPPORT====================
    GetPage(name: AppRoutes.privacyPolicy, page: () => const PrivacyPolicyScreen(), binding: LegalContentBinding()),
    GetPage(name: AppRoutes.orderSupportScreen, page: () => OrderSupportScreen()),
    GetPage(name: AppRoutes.contactUsScreen, page: () => ContactUsScreen()),
    GetPage(name: AppRoutes.accountIssuesScreen, page: () => AccountIssuesScreen()),
    GetPage(name: AppRoutes.generalIssuesScreen, page: () => GeneralIssuesScreen()),

    //===================SELLER ====================
    GetPage(name: AppRoutes.createQualityListingScreen, page: () => CreateQualityListingScreen(), binding: CreateProductBinding()),
    GetPage(name: AppRoutes.scheduleLiveShowScreen, page: () => ScheduleLiveShowScreen(), binding: ScheduleShowBinding()),
    GetPage(
      name: AppRoutes.fulfillmentScreen,
      page: () => FulfillmentScreen(),
      binding: FulfillmentBinding(),
    ),
    GetPage(
      name: AppRoutes.sellerPayoutScreen,
      page: () => SellerPayoutScreen(),
      binding: SellerPayoutBinding(),
    ),
    GetPage(
      name: AppRoutes.payoutHistoryScreen,
      page: () => PayoutHistoryScreen(),
      binding: PayoutHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.sellerOrderScreen,
      page: () => SellerOrderScreen(),
      binding: SellerOrdersBinding(),
    ),
    GetPage(name: AppRoutes.sellerInventoryScreen, page: () => SellerInventoryScreen(), binding: SellerInventoryBinding()),
    GetPage(name: AppRoutes.sellerToolsScreen, page: () => SellerToolScreen()),
    GetPage(
      name: AppRoutes.sellerAnalyticsScreen,
      page: () => const SellerAnalyticsScreen(),
      binding: SellerAnalyticsBinding(),
    ),
    GetPage(name: AppRoutes.showsScreen, page: () => ShowsScreen(), binding: ShowsBinding()),
    GetPage(name: AppRoutes.offersScreen, page: () => OffersScreen()),
    GetPage(
      name: AppRoutes.tipsScreen,
      page: () => TipsScreen(),
      binding: SellerTipsBinding(),
    ),
    GetPage(name: AppRoutes.inviteSellerScreen, page: () => InviteSellerScreen()),
    GetPage(name: AppRoutes.promoteToolScreen, page: () => PromoteToolsScreen()),
    GetPage(name: AppRoutes.createShippingProfileScreen, page: () => CreateShippingProfileScreen()),
    GetPage(name: AppRoutes.shippingScreen, page: () => ShippingScreen()),
    GetPage(name: AppRoutes.permissionsScreen, page: () => PermissionsScreen()),
    GetPage(name: AppRoutes.startShowScreen, page: () => const StartShowScreen(), binding: StartShowBinding()),
    GetPage(name: AppRoutes.rehearsalScreen, page: () => const RehearsalScreen(), binding: RehearsalBinding()),
    GetPage(name: AppRoutes.shippingProfilesScreen, page: () => ShippingProfilesScreen()),
    GetPage(name: AppRoutes.startAuctionScreen, page: () => const StartAuctionScreen(), binding: StartAuctionBinding()),
    GetPage(name: AppRoutes.endShowInsightsScreen, page: () => const EndShowInsightsScreen(), binding: EndShowInsightsBinding()),
    GetPage(name: AppRoutes.premierShopScreen, page: () => const PremierShopScreen(), binding: PremierShopBinding()),

    //===================SELLER VERIFICATION====================
    GetPage(name: AppRoutes.sellerFaqScreen, page: () => const SellerFaqScreen<SellerFaqController>(), binding: FaqBinding()),
    GetPage(name: AppRoutes.globalFaqScreen, page: () => const SellerFaqScreen<GlobalFaqController>(), binding: FaqBinding()),
    GetPage(name: AppRoutes.readyToEarnScreen, page: () => ReadyToEarnScreen()),
    // SellerVerificationBinding registered here — all subsequent screens share the same controller
    GetPage(name: AppRoutes.sellerCategoryScreen, page: () => SellerCategoryScreen(), binding: SellerVerificationBinding()),
    GetPage(name: AppRoutes.sellerSubCategoryScreen, page: () => SellerSubcategoryScreen()),
    GetPage(name: AppRoutes.sellerTypeScreen, page: () => SellerTypeScreen()),
    GetPage(name: AppRoutes.sellerAddressScreen, page: () => SellerAddressScreen()),
    GetPage(name: AppRoutes.sellerAverageEarningScreen, page: () => SellerAverageEarning()),
    GetPage(name: AppRoutes.sellerKycScreen, page: () => SellerKycScreen()),
    //===================MISC====================
    GetPage(name: AppRoutes.errorScreen, page: () => ErrorScreen()),
    GetPage(name: AppRoutes.walletScreen, page: () => WalletScreen(), binding: WalletBinding()),
  ];
}