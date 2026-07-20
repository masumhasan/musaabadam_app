class ApiConstants {
  ApiConstants._();

  // Switch base URL based on environment:
  // Android emulator → 10.0.2.2 maps to host machine localhost
  // iOS simulator    → 127.0.0.1
  // Physical device  → use your machine's LAN IP
  static const String _devBaseUrl = 'https://backend.bidsrush.com/api/v1';
  static const String _prodBaseUrl = 'https://backend.bidsrush.com/api/v1';

  static const bool _isProduction = bool.fromEnvironment('dart.vm.product');
  static const String baseUrl = _isProduction ? _prodBaseUrl : _devBaseUrl;

  // Socket.io server (same host, no /api/v1 path prefix)
  static const String _devSocketUrl = 'https://backend.bidsrush.com';
  static const String _prodSocketUrl = 'https://backend.bidsrush.com';
  static const String socketUrl = _isProduction ? _prodSocketUrl : _devSocketUrl;


  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String verifyEmail = '/auth/verify-email';
  static const String resendVerification = '/auth/resend-verification';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetOtp = '/auth/verify-reset-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String refreshToken = '/auth/refresh-token';

  // Users
  static const String myProfile = '/users/profile';
  static String userProfile(String userId) => '/users/$userId';
  static const String addresses = '/users/addresses';
  static String addressById(String id) => '/users/addresses/$id';
  static const String notificationPreferences = '/users/notification-preferences';
  static const String appPreferences = '/users/app-preferences';

  // Social — follow / unfollow / block
  static String followUser(String userId) => '/users/$userId/follow';
  static String userFollowers(String userId) => '/users/$userId/followers';
  static String userFollowing(String userId) => '/users/$userId/following';
  static String blockUser(String userId) => '/users/$userId/block';
  static const String blockedUsers = '/users/blocked';

  // Categories
  static const String categories = '/categories';

  // Products
  static const String products = '/products';
  static String product(String id) => '/products/$id';
  static const String productInventory = '/products/inventory';
  static String publishProduct(String id) => '/products/$id/publish';
  static String deactivateProduct(String id) => '/products/$id/deactivate';
  static String flashSale(String id) => '/products/$id/flash-sale';

  // Search
  static const String search = '/search';

  // Wishlist / favorites
  static const String favorites = '/favorites';
  static String toggleFavorite(String productId) => '/favorites/$productId';

  // Reports
  static const String reports = '/reports';

  // Giveaways
  static const String giveaways = '/giveaways';
  static String joinGiveaway(String id) => '/giveaways/$id/join';
  static String drawGiveaway(String id) => '/giveaways/$id/draw';
  static String cancelGiveaway(String id) => '/giveaways/$id/cancel';
  static String streamGiveaways(String streamId) => '/giveaways/stream/$streamId';

  // Reviews
  static const String reviews = '/reviews';
  static const String reviewableOrders = '/reviews/reviewable';
  static String sellerReviews(String sellerId) => '/reviews/seller/$sellerId';

  // Notifications
  static const String notifications = '/notifications';
  static const String notificationsUnreadCount = '/notifications/unread-count';
  static const String notificationsReadAll = '/notifications/read-all';
  static String notificationRead(String id) => '/notifications/$id/read';

  // Referral
  static const String referral = '/users/referral';

  // Seller application
  static const String sellerApplication = '/users/seller-application';
  static const String updateKyc = '/users/kyc';

  // Change email / password (authenticated)
  static const String changeEmailInitiate = '/auth/change-email/initiate';
  static const String changeEmailVerify = '/auth/change-email/verify';
  static const String changePasswordInitiate = '/auth/change-password/initiate';
  static const String changePasswordVerify = '/auth/change-password/verify';

  // Legal content & settings (public / authenticated)
  static const String legalPrivacyPolicy = '/settings/privacy-policy';
  static const String legalTerms = '/settings/terms';
  static const String platformSettings = '/settings/platform';
  static const String faqs = '/settings/faqs';
  static const String premierShopConfig = '/settings/premier-shop';
  static const String sellerPremierShopStatus = '/settings/seller-premier-shop-status';


  // Streams
  static const String streams = '/streams';
  static String stream(String streamId) => '/streams/$streamId';
  static String joinStream(String streamId) => '/streams/$streamId/join';
  static String startStream(String streamId) => '/streams/$streamId/start';
  static String endStream(String streamId) => '/streams/$streamId/end';
  static String updateStream(String streamId) => '/streams/$streamId';
  static String cancelStream(String streamId) => '/streams/$streamId/cancel';
  static String publishStream(String streamId) => '/streams/$streamId/publish';
  static String deleteStream(String streamId) => '/streams/$streamId';
  static String pinStreamProduct(String streamId) => '/streams/$streamId/pin';
  static String unpinStreamProduct(String streamId) => '/streams/$streamId/unpin';
  static const String myStreams = '/streams/me/streams';
  static const String streamFeed = '/streams/feed';

  // Replays (past shows)
  static const String replays = '/streams/replays';
  static String streamReplay(String streamId) => '/streams/$streamId/replay';

  // Uploads
  static const String presignedUploadUrl = '/uploads/presigned-url';

  // Orders
  static const String orders = '/orders';
  static const String myOrders = '/orders/my';
  static const String sellerOrders = '/orders/seller';
  
  // Offers
  static const String offers = '/offers';
  static const String buyerOffers = '/offers/buyer';
  static const String sellerOffers = '/offers/seller';
  static String orderDetail(String orderId) => '/orders/$orderId';
  static String cancelOrder(String orderId) => '/orders/$orderId/cancel';
  static String completeOrder(String orderId) => '/orders/$orderId/complete';
  static String orderAddress(String orderId) => '/orders/$orderId/address';
  static String updateOrderStatus(String orderId) => '/orders/$orderId/status';

  // Analytics
  static const String sellerAnalyticsOverview = '/analytics/seller/overview';
  static const String sellerAnalyticsRevenue = '/analytics/seller/revenue';
  static const String adminAnalyticsOverview = '/analytics/admin/overview';
  static const String adminAnalyticsRevenue = '/analytics/admin/revenue';

  // Bidding
  static String placeBid(String productId) => '/products/$productId/bid';

  // Auctions
  static const String startAuction = '/auctions/start';
  static String pauseAuction(String productId) => '/auctions/$productId/pause';
  static String resumeAuction(String productId) => '/auctions/$productId/resume';
  static String cancelAuction(String productId) => '/auctions/$productId/cancel';
  static String closeAuction(String productId) => '/auctions/$productId/close';
  static String auctionBids(String productId) => '/auctions/$productId/bids';
  static const String myBids = '/auctions/my';

  // Chat
  static String chatMessages(String streamId) => '/chat/streams/$streamId/messages';
  static String deleteChatMessage(String messageId) => '/chat/messages/$messageId';

  // Shipping
  static const String shippingProfiles = '/shipping/profiles';
  static String shippingProfile(String id) => '/shipping/profiles/$id';
  static String shippingEstimate(String productId) => '/shipping/estimate/$productId';
  static String generateLabel(String orderId) => '/shipping/orders/$orderId/label';
  static String trackOrder(String orderId) => '/shipping/orders/$orderId/track';

  // Payments / escrow / wallet
  static const String paymentMethods = '/payments/methods';
  static String paymentMethod(String id) => '/payments/methods/$id';
  static String setDefaultPaymentMethod(String id) => '/payments/methods/$id/default';
  static String checkoutOrder(String orderId) => '/payments/orders/$orderId/checkout';
  static String confirmOrderPayment(String orderId) => '/payments/orders/$orderId/confirm';
  static String refundOrder(String orderId) => '/payments/orders/$orderId/refund';
  static const String wallet = '/payments/wallet';
  static const String walletLedger = '/payments/wallet/ledger';
  static const String payouts = '/payments/payouts';
  static const String payoutAccount = '/payments/payout-account';
  static const String payoutOnboard = '/payments/payout-account/onboard';

  // Auction streams
  static const String createAuctionStream = '/streams/auction';

  // Direct Messages (DMs)
  static const String dmConversations = '/dms/conversations';
  static String dmMessages(String partnerId) => '/dms/messages/$partnerId';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'cached_user';
}
