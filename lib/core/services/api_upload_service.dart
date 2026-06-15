import 'dart:io';
import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

class ApiUploadService {
  ApiUploadService._();
  static final ApiUploadService instance = ApiUploadService._();

  final Dio _dio = ApiClient.instance;

  /// Generates a presigned S3 upload URL and returns the public URL.
  /// [folder]: 'profile' | 'product' | 'stream_thumbnail'
  Future<UploadResult> getPresignedUrl({
    required String folder,
    required String contentType,
    required int fileSize,
  }) async {
    final response = await _dio.post(ApiConstants.presignedUploadUrl, data: {
      'folder': folder,
      'contentType': contentType,
      'fileSize': fileSize,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    return UploadResult(
      uploadUrl: data['uploadUrl'] as String,
      publicUrl: data['publicUrl'] as String,
      key: data['key'] as String,
    );
  }

  /// Uploads [file] directly to S3 via the presigned URL.
  Future<String> uploadFile({
    required File file,
    required String folder,
    required String contentType,
  }) async {
    final fileSize = await file.length();
    final result = await getPresignedUrl(
      folder: folder,
      contentType: contentType,
      fileSize: fileSize,
    );

    final uploadDio = Dio();
    final bytes = await file.readAsBytes();
    await uploadDio.put(
      result.uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {
          HttpHeaders.contentTypeHeader: contentType,
          HttpHeaders.contentLengthHeader: fileSize,
        },
      ),
    );

    return result.publicUrl;
  }
}

class UploadResult {
  final String uploadUrl;
  final String publicUrl;
  final String key;

  const UploadResult({
    required this.uploadUrl,
    required this.publicUrl,
    required this.key,
  });
}
