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
  final bool isRecorded;
  final String? recordingUrl;
  final String recordingStatus; // none | processing | ready | failed
  final int? recordingDurationSeconds;

  final String? videoPreviewUrl;
  final String primarySellingFormat;
  final String repeatOption;
  final String? shippingSettings;
  final bool freePickup;
  final bool explicitContent;
  final List<String> mutedWords;
  final String primaryLanguage;
  final List<String> moderatorIds;

  const StreamModel({
    required this.id,
    required this.sellerId,
    this.sellerName,
    this.sellerAvatarUrl,
    required this.title,
    this.description,
    this.categoryId,
    this.thumbnailUrl,
    this.videoPreviewUrl,
    this.primarySellingFormat = 'auction',
    this.repeatOption = 'doesNotRepeat',
    this.shippingSettings,
    this.freePickup = false,
    this.explicitContent = false,
    this.mutedWords = const [],
    this.primaryLanguage = 'English',
    this.moderatorIds = const [],
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
    this.isRecorded = false,
    this.recordingUrl,
    this.recordingStatus = 'none',
    this.recordingDurationSeconds,
  });

  bool get isLive => status == 'live';
  bool get isScheduled => status == 'scheduled';
  bool get isEnded => status == 'ended';

  /// A past show that has a stored replay ready to watch.
  bool get hasReplay => recordingStatus == 'ready' && (recordingUrl?.isNotEmpty ?? false);

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
      videoPreviewUrl: json['videoPreviewUrl'] as String?,
      primarySellingFormat: json['primarySellingFormat'] as String? ?? 'auction',
      repeatOption: json['repeatOption'] as String? ?? 'doesNotRepeat',
      shippingSettings: json['shippingSettings'] as String?,
      freePickup: json['freePickup'] as bool? ?? false,
      explicitContent: json['explicitContent'] as bool? ?? false,
      mutedWords: List<String>.from(json['mutedWords'] ?? []),
      primaryLanguage: json['primaryLanguage'] as String? ?? 'English',
      moderatorIds: (json['moderatorIds'] as List? ?? []).map((e) => _extractId(e)).where((e) => e.isNotEmpty).toList(),
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
      isRecorded: json['isRecorded'] as bool? ?? false,
      recordingUrl: json['recordingUrl'] as String?,
      recordingStatus: json['recordingStatus'] as String? ?? 'none',
      recordingDurationSeconds: json['recordingDurationSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sellerId': sellerId,
        'title': title,
        'description': description,
        'categoryId': categoryId,
        'thumbnailUrl': thumbnailUrl,
        'videoPreviewUrl': videoPreviewUrl,
        'primarySellingFormat': primarySellingFormat,
        'repeatOption': repeatOption,
        'shippingSettings': shippingSettings,
        'freePickup': freePickup,
        'explicitContent': explicitContent,
        'mutedWords': mutedWords,
        'primaryLanguage': primaryLanguage,
        'moderatorIds': moderatorIds,
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
        'isRecorded': isRecorded,
        'recordingUrl': recordingUrl,
        'recordingStatus': recordingStatus,
        'recordingDurationSeconds': recordingDurationSeconds,
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

/// Result of requesting a past show's replay (recorded video stored in S3).
class ReplayResult {
  final String streamId;
  final String recordingUrl;
  final String recordingStatus;
  final int? recordingDurationSeconds;
  final StreamModel stream;

  const ReplayResult({
    required this.streamId,
    required this.recordingUrl,
    required this.recordingStatus,
    this.recordingDurationSeconds,
    required this.stream,
  });

  factory ReplayResult.fromJson(Map<String, dynamic> json) {
    return ReplayResult(
      streamId: json['streamId'] as String,
      recordingUrl: json['recordingUrl'] as String,
      recordingStatus: json['recordingStatus'] as String? ?? 'ready',
      recordingDurationSeconds: json['recordingDurationSeconds'] as int?,
      stream: StreamModel.fromJson(json['stream'] as Map<String, dynamic>),
    );
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
