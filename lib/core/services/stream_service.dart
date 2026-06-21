import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class StreamService {
  StreamService._();
  static final StreamService instance = StreamService._();

  final Dio _dio = ApiClient.instance;

  // ─── Seller: Create a stream ───────────────────────────────────────────────

  Future<StreamModel> createStream({
    required String title,
    String? description,
    String? categoryId,
    String? thumbnailUrl,
    List<String>? tags,
    DateTime? scheduledAt,
    bool chatEnabled = true,
  }) async {
    final response = await _dio.post(ApiConstants.streams, data: {
      'title': title,
      'description': ?description,
      'categoryId': ?categoryId,
      'thumbnailUrl': ?thumbnailUrl,
      'tags': ?tags,
      'scheduledAt': ?scheduledAt?.toUtc().toIso8601String(),
      'chatEnabled': chatEnabled,
    });
    return StreamModel.fromJson(response.data['data']['stream'] as Map<String, dynamic>);
  }

  // ─── Seller: Start an auction stream immediately ───────────────────────────

  Future<JoinStreamResult> createAuctionStream({
    required String productId,
    required String title,
    String? description,
    String? categoryId,
    String? thumbnailUrl,
    List<String>? tags,
    bool chatEnabled = true,
  }) async {
    final response = await _dio.post(ApiConstants.createAuctionStream, data: {
      'productId': productId,
      'title': title,
      'description': ?description,
      'categoryId': ?categoryId,
      'thumbnailUrl': ?thumbnailUrl,
      'tags': ?tags,
      'chatEnabled': chatEnabled,
    });
    return JoinStreamResult.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ─── Seller: Update a scheduled stream ────────────────────────────────────

  Future<StreamModel> updateStream(String streamId, {
    String? title,
    String? description,
    String? categoryId,
    String? thumbnailUrl,
    List<String>? tags,
    DateTime? scheduledAt,
    bool? chatEnabled,
  }) async {
    final response = await _dio.patch(ApiConstants.updateStream(streamId), data: {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (categoryId != null) 'categoryId': categoryId,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (tags != null) 'tags': tags,
      if (scheduledAt != null) 'scheduledAt': scheduledAt.toUtc().toIso8601String(),
      if (chatEnabled != null) 'chatEnabled': chatEnabled,
    });
    return StreamModel.fromJson(response.data['data']['stream'] as Map<String, dynamic>);
  }

  // ─── Seller: Start / End / Cancel ─────────────────────────────────────────

  Future<StreamModel> startStream(String streamId) async {
    final response = await _dio.patch(ApiConstants.startStream(streamId));
    return StreamModel.fromJson(response.data['data']['stream'] as Map<String, dynamic>);
  }

  Future<StreamModel> endStream(String streamId) async {
    final response = await _dio.patch(ApiConstants.endStream(streamId));
    return StreamModel.fromJson(response.data['data']['stream'] as Map<String, dynamic>);
  }

  Future<StreamModel> cancelStream(String streamId) async {
    final response = await _dio.patch(ApiConstants.cancelStream(streamId));
    return StreamModel.fromJson(response.data['data']['stream'] as Map<String, dynamic>);
  }

  // ─── Viewer: Join a stream ─────────────────────────────────────────────────

  Future<JoinStreamResult> joinStream(String streamId) async {
    final response = await _dio.post(ApiConstants.joinStream(streamId));
    return JoinStreamResult.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ─── List streams ──────────────────────────────────────────────────────────

  Future<List<StreamModel>> getLiveStreams({String? categoryId, int page = 1}) async {
    final response = await _dio.get(ApiConstants.streams, queryParameters: {
      'status': 'live',
      'page': page,
      'limit': 20,
      'categoryId': ?categoryId,
    });
    final list = response.data['data']['streams'] as List;
    return list.map((e) => StreamModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<StreamModel>> getScheduledStreams({int page = 1}) async {
    final response = await _dio.get(ApiConstants.streams, queryParameters: {
      'status': 'scheduled',
      'page': page,
      'limit': 20,
    });
    final list = response.data['data']['streams'] as List;
    return list.map((e) => StreamModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<StreamModel> getStream(String streamId) async {
    final response = await _dio.get(ApiConstants.stream(streamId));
    return StreamModel.fromJson(response.data['data']['stream'] as Map<String, dynamic>);
  }

  // ─── Replays (past shows) ──────────────────────────────────────────────────

  /// List ended shows that have a stored replay ready to watch.
  Future<List<StreamModel>> getReplays({String? categoryId, String? sellerId, int page = 1}) async {
    final response = await _dio.get(ApiConstants.replays, queryParameters: {
      'page': page,
      'limit': 20,
      'categoryId': ?categoryId,
      'sellerId': ?sellerId,
    });
    final list = response.data['data']['streams'] as List;
    return list.map((e) => StreamModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Resolve the playable recording URL for a single past show.
  Future<ReplayResult> getReplay(String streamId) async {
    final response = await _dio.get(ApiConstants.streamReplay(streamId));
    return ReplayResult.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ─── Seller: Own streams list ──────────────────────────────────────────────

  Future<List<StreamModel>> getMyStreams({String? status, int page = 1}) async {
    final response = await _dio.get(ApiConstants.myStreams, queryParameters: {
      'page': page,
      'limit': 20,
      'status': ?status,
    });
    final list = response.data['data']['streams'] as List;
    return list.map((e) => StreamModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ─── Error helper ──────────────────────────────────────────────────────────

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
      if (data is Map && data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          return (errors.first as Map)['message'] as String? ?? 'Unknown error';
        }
      }
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
