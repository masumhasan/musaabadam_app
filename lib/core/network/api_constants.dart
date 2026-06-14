class ApiConstants {
  ApiConstants._();

  // Switch base URL based on environment:
  // Android emulator → 10.0.2.2 maps to host machine localhost
  // iOS simulator    → 127.0.0.1
  // Physical device  → set your machine's LAN IP here
  static const String _devBaseUrl = 'http://10.0.2.2:3000/api/v1';
  static const String _prodBaseUrl = 'https://api.bidsrush.com/api/v1';

  static const bool _isProduction = bool.fromEnvironment('dart.vm.product');
  static const String baseUrl = _isProduction ? _prodBaseUrl : _devBaseUrl;

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

  // Seller application
  static const String sellerApplication = '/users/seller-application';

  // Legal content (public)
  static const String legalPrivacyPolicy = '/settings/privacy-policy';
  static const String legalTerms = '/settings/terms';

  // Streams
  static const String streams = '/streams';
  static String stream(String streamId) => '/streams/$streamId';
  static String joinStream(String streamId) => '/streams/$streamId/join';
  static String startStream(String streamId) => '/streams/$streamId/start';
  static String endStream(String streamId) => '/streams/$streamId/end';
  static String cancelStream(String streamId) => '/streams/$streamId/cancel';
  static const String myStreams = '/streams/me/streams';

  // Storage keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'cached_user';
}
