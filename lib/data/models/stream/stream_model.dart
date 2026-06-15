class StreamModel {
  final String id;
  final String sellerId;
  final String? sellerName;
  final String? sellerAvatarUrl;
  final String title;
  final String? description;
  final String? categoryId;
  final String? thumbnailUrl;
  final List<String> tags;
  final List<String> pinnedProducts;
  final String status;
  final String callId;
  final String callType;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int totalViewers;
  final int peakViewerCount;
  final bool chatEnabled;
  final DateTime createdAt;

  const StreamModel({
    required this.id,
    required this.sellerId,
    this.sellerName,
    this.sellerAvatarUrl,
    required this.title,
    this.description,
    this.categoryId,
    this.thumbnailUrl,
    required this.tags,
    required this.pinnedProducts,
    required this.status,
    required this.callId,
    required this.callType,
    this.scheduledAt,
    this.startedAt,
    this.endedAt,
    required this.totalViewers,
    required this.peakViewerCount,
    required this.chatEnabled,
    required this.createdAt,
  });

  bool get isLive => status == 'live';
  bool get isScheduled => status == 'scheduled';
  bool get isEnded => status == 'ended';

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    final sellerRaw = json['sellerId'];
    final sellerMap = sellerRaw is Map ? sellerRaw : null;
    return StreamModel(
      id: json['id'] as String? ?? json['_id'] as String,
      sellerId: _extractId(sellerRaw),
      sellerName: sellerMap?['displayName'] as String? ?? sellerMap?['username'] as String?,
      sellerAvatarUrl: sellerMap?['avatarUrl'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      categoryId: _extractIdOrNull(json['categoryId']),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      pinnedProducts: (json['pinnedProducts'] as List? ?? [])
          .map((e) => e is String ? e : (e as Map)['_id'] as String? ?? '')
          .where((e) => e.isNotEmpty)
          .toList(),
      status: json['status'] as String,
      callId: json['callId'] as String,
      callType: json['callType'] as String? ?? 'livestream',
      scheduledAt: json['scheduledAt'] != null ? DateTime.parse(json['scheduledAt'] as String) : null,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt'] as String) : null,
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
      totalViewers: json['totalViewers'] as int? ?? 0,
      peakViewerCount: json['peakViewerCount'] as int? ?? 0,
      chatEnabled: json['chatEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sellerId': sellerId,
        'title': title,
        'description': description,
        'categoryId': categoryId,
        'thumbnailUrl': thumbnailUrl,
        'tags': tags,
        'pinnedProducts': pinnedProducts,
        'status': status,
        'callId': callId,
        'callType': callType,
        'scheduledAt': scheduledAt?.toIso8601String(),
        'startedAt': startedAt?.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'totalViewers': totalViewers,
        'peakViewerCount': peakViewerCount,
        'chatEnabled': chatEnabled,
        'createdAt': createdAt.toIso8601String(),
      };

  static String _extractId(dynamic v) {
    if (v is String) return v;
    if (v is Map) return v['_id'] as String? ?? v['id'] as String? ?? '';
    return '';
  }

  static String? _extractIdOrNull(dynamic v) {
    if (v == null) return null;
    return _extractId(v);
  }
}

class JoinStreamResult {
  final String token;
  final String callId;
  final String callType;
  final String apiKey;
  final String role;
  final StreamModel stream;

  const JoinStreamResult({
    required this.token,
    required this.callId,
    required this.callType,
    required this.apiKey,
    required this.role,
    required this.stream,
  });

  factory JoinStreamResult.fromJson(Map<String, dynamic> json) {
    return JoinStreamResult(
      token: json['token'] as String,
      callId: json['callId'] as String,
      callType: json['callType'] as String? ?? 'livestream',
      apiKey: json['apiKey'] as String,
      role: json['role'] as String,
      stream: StreamModel.fromJson(json['stream'] as Map<String, dynamic>),
    );
  }
}
