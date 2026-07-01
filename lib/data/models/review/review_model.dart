class ReviewModel {
  final String id;
  final int rating;
  final String? comment;
  final String buyerName;
  final String? buyerAvatarUrl;
  final String? sellerReply;
  final DateTime? createdAt;

  const ReviewModel({
    required this.id,
    required this.rating,
    this.comment,
    required this.buyerName,
    this.buyerAvatarUrl,
    this.sellerReply,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final buyer = json['buyer'] is Map ? Map<String, dynamic>.from(json['buyer'] as Map) : const {};
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      comment: json['comment']?.toString(),
      buyerName: buyer['displayName']?.toString() ?? 'Buyer',
      buyerAvatarUrl: buyer['avatarUrl']?.toString(),
      sellerReply: json['sellerReply']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}

class SellerReviews {
  final List<ReviewModel> reviews;
  final double averageRating;
  final int ratingCount;

  const SellerReviews({this.reviews = const [], this.averageRating = 0, this.ratingCount = 0});

  factory SellerReviews.fromJson(Map<String, dynamic> json) => SellerReviews(
        reviews: (json['reviews'] as List? ?? [])
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
        ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      );
}
