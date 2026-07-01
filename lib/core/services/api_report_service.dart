import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

class ApiReportService {
  ApiReportService._();
  static final ApiReportService instance = ApiReportService._();

  final Dio _dio = ApiClient.instance;

  static const reasons = <String, String>{
    'spam': 'Spam',
    'harassment': 'Harassment',
    'inappropriate': 'Inappropriate content',
    'scam': 'Scam / fraud',
    'counterfeit': 'Counterfeit',
    'other': 'Other',
  };

  Future<void> submit({
    required String targetType, // user | seller | stream | product | message
    required String targetId,
    required String reason,
    String? details,
  }) async {
    await _dio.post(ApiConstants.reports, data: {
      'targetType': targetType,
      'targetId': targetId,
      'reason': reason,
      'details': ?details,
    });
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }

  /// Reusable report bottom-sheet: pick a reason → submit.
  static void showReportSheet({required String targetType, required String targetId}) {
    Get.bottomSheet(
      _ReportSheet(targetType: targetType, targetId: targetId),
      isScrollControlled: true,
    );
  }
}

class _ReportSheet extends StatelessWidget {
  final String targetType;
  final String targetId;
  const _ReportSheet({required this.targetType, required this.targetId});

  @override
  Widget build(BuildContext context) {
    final detailsCtrl = TextEditingController();
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            for (final entry in ApiReportService.reasons.entries)
              ListTile(
                title: Text(entry.value),
                onTap: () async {
                  Get.back();
                  try {
                    await ApiReportService.instance.submit(
                      targetType: targetType,
                      targetId: targetId,
                      reason: entry.key,
                      details: detailsCtrl.text.trim().isEmpty ? null : detailsCtrl.text.trim(),
                    );
                    Get.snackbar('Reported', 'Thanks — our team will review this.',
                        snackPosition: SnackPosition.BOTTOM);
                  } on DioException catch (e) {
                    Get.snackbar('Report', ApiReportService.extractError(e), snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
