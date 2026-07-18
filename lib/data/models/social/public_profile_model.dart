class PublicProfileModel {
  final String id;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String? coverImageUrl;
  final String? bio;
  final String? location;
  final String role;
  final int followersCount;
  final int followingCount;
  final double buyerRating;
  final bool isSellerApproved;
  final bool isFollowing;
  final bool isBlockedByMe;
  final Map<String, dynamic>? sellerProfile;
  final DateTime createdAt;

  const PublicProfileModel({
    required this.id,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.coverImageUrl,
    this.bio,
    this.location,
    required this.role,
    required this.followersCount,
    required this.followingCount,
    required this.buyerRating,
    required this.isSellerApproved,
    required this.isFollowing,
    required this.isBlockedByMe,
    this.sellerProfile,
    required this.createdAt,
  });

  factory PublicProfileModel.fromJson(Map<String, dynamic> json) {
    return PublicProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      role: json['role'] as String? ?? 'buyer',
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      buyerRating: (json['buyerRating'] as num?)?.toDouble() ?? 0.0,
      isSellerApproved: json['isSellerApproved'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      isBlockedByMe: json['isBlockedByMe'] as bool? ?? false,
      sellerProfile: json['sellerProfile'] is Map<String, dynamic>
          ? json['sellerProfile'] as Map<String, dynamic>
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String get displayNameOrUsername =>
      displayName?.isNotEmpty == true ? displayName! : username;

  bool get isSeller => role == 'seller';
}
