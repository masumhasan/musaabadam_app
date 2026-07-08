import '../address/address_model.dart';

class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String username;
  final String? displayName;
  final String? avatarUrl;
  final String? coverImageUrl;
  final String? bio;
  final String? location;
  final String role;
  final List<String> permissions;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final int followersCount;
  final int followingCount;
  final double buyerRating;
  final double walletBalance;
  final int rewardPoints;
  final String? referralCode;
  final bool isSellerApproved;
  final bool isSuspended;
  final String? accountHealth;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final List<AddressModel> addresses;

  const UserModel({
    required this.id,
    required this.email,
    this.phone,
    required this.username,
    this.displayName,
    this.avatarUrl,
    this.coverImageUrl,
    this.bio,
    this.location,
    required this.role,
    required this.permissions,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.followersCount,
    required this.followingCount,
    required this.buyerRating,
    required this.walletBalance,
    required this.rewardPoints,
    this.referralCode,
    required this.isSellerApproved,
    required this.isSuspended,
    this.accountHealth,
    required this.createdAt,
    this.lastLoginAt,
    this.addresses = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      username: json['username'] as String,
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      role: json['role'] as String,
      permissions: List<String>.from(json['permissions'] ?? []),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      followersCount: json['followersCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      buyerRating: (json['buyerRating'] as num?)?.toDouble() ?? 0.0,
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      rewardPoints: json['rewardPoints'] as int? ?? 0,
      referralCode: json['referralCode'] as String?,
      isSellerApproved: json['isSellerApproved'] as bool? ?? false,
      isSuspended: json['isSuspended'] as bool? ?? false,
      accountHealth: json['accountHealth'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      addresses: (json['addresses'] as List<dynamic>?)
              ?.map((a) => AddressModel.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'phone': phone,
        'username': username,
        'displayName': displayName,
        'avatarUrl': avatarUrl,
        'coverImageUrl': coverImageUrl,
        'bio': bio,
        'location': location,
        'role': role,
        'permissions': permissions,
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'buyerRating': buyerRating,
        'walletBalance': walletBalance,
        'rewardPoints': rewardPoints,
        'referralCode': referralCode,
        'isSellerApproved': isSellerApproved,
        'isSuspended': isSuspended,
        'accountHealth': accountHealth,
        'createdAt': createdAt.toIso8601String(),
        'lastLoginAt': lastLoginAt?.toIso8601String(),
        'addresses': addresses.map((a) => a.toJson()).toList(),
      };

  bool get isSeller => role == 'seller';
  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator';
  bool get isCohost => role == 'cohost';

  bool hasPermission(String permission) {
    return permissions.contains('*') || permissions.contains(permission);
  }

  String get displayNameOrUsername => displayName?.isNotEmpty == true ? displayName! : username;
}
