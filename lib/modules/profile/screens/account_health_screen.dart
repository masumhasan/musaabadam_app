import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/api_upload_service.dart';
import 'package:musaab_adam/core/services/seller_service.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class AccountHealthScreen extends StatefulWidget {
  const AccountHealthScreen({super.key});

  @override
  State<AccountHealthScreen> createState() => _AccountHealthScreenState();
}

class _AccountHealthScreenState extends State<AccountHealthScreen> {
  String? _identityDocUrl;
  String? _businessLicenseUrl;
  bool _identityDocUploading = false;
  bool _businessLicenseUploading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = Get.find<AuthController>().currentUser.value;
    _identityDocUrl = user?.sellerProfile?['identityDocUrl'] as String?;
    _businessLicenseUrl = user?.sellerProfile?['businessLicenseUrl'] as String?;
  }

  Future<void> _pickIdentityDoc() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    setState(() {
      _identityDocUploading = true;
    });

    try {
      final url = await ApiUploadService.instance.uploadFile(
        file: File(picked.path),
        folder: 'profile',
        contentType: 'image/jpeg',
      );
      setState(() {
        _identityDocUrl = url;
      });
      Get.snackbar('Success', 'Identity document uploaded locally.', snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Upload Error', 'Failed to upload identity document.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        _identityDocUploading = false;
      });
    }
  }

  Future<void> _pickBusinessLicense() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    setState(() {
      _businessLicenseUploading = true;
    });

    try {
      final url = await ApiUploadService.instance.uploadFile(
        file: File(picked.path),
        folder: 'profile',
        contentType: 'image/jpeg',
      );
      setState(() {
        _businessLicenseUrl = url;
      });
      Get.snackbar('Success', 'Business license uploaded locally.', snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Upload Error', 'Failed to upload business license.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        _businessLicenseUploading = false;
      });
    }
  }

  Future<void> _submitKycUpdate() async {
    if (_identityDocUrl == null) {
      Get.snackbar('Required', 'Please upload your identity document first.', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await SellerService.instance.updateKyc(
        identityDocUrl: _identityDocUrl,
        businessLicenseUrl: _businessLicenseUrl,
      );

      // Fetch and update local profile state
      final updatedUser = await ApiAuthService.instance.getMyProfile();
      await TokenStorageService.instance.saveUser(updatedUser);
      Get.find<AuthController>().currentUser.value = updatedUser;

      Get.snackbar('Success', 'KYC documents updated and submitted for review successfully.',
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    } on DioException catch (e) {
      Get.snackbar('Error', SellerService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Failed to update KYC documents. Please try again.', snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = Get.find<AuthController>().currentUser.value;
    final health = user?.accountHealth ?? 'Action Required';

    double gaugeValue = 2.0;
    Color healthColor = Colors.red;

    if (health == 'Excellent') {
      gaugeValue = 9.0;
      healthColor = const Color(0xFF10B981);
    } else if (health == 'Good') {
      gaugeValue = 7.0;
      healthColor = Colors.teal;
    } else if (health == 'Average') {
      gaugeValue = 4.5;
      healthColor = Colors.amber;
    } else {
      // Action Required
      gaugeValue = 2.0;
      healthColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(text: AppStrings.accountHealth, fontSize: 18, fontWeight: FontWeight.w700),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: AppStrings.policyStanding, fontWeight: FontWeight.w600),
            SizedBox(height: 10.h),
            CustomText(
              text: 'Our policy is to ensure transparency, safety, and compliance. Your account health directly reflects your document status and community standing.',
              textAlignment: TextAlign.start,
              fontSize: 14.sp,
              fontColor: colorScheme.outline,
            ),
            SizedBox(height: 25.h),
            
            // Arch Gauge Center
            Center(
              child: SizedBox(
                height: 130.h, // Adjusted height since bottom half is transparent
                width: 200.w,
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 0,
                      child: SizedBox(
                        height: 200.h,
                        width: 200.w,
                        child: PieChart(
                          PieChartData(
                            startDegreeOffset: 180, // Horizontal arch
                            sectionsSpace: 0,
                            centerSpaceRadius: 70.r,
                            sections: [
                              PieChartSectionData(
                                value: gaugeValue,
                                radius: 12.r,
                                color: healthColor,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: 10 - gaugeValue,
                                radius: 12.r,
                                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: 10,
                                radius: 12.r,
                                color: Colors.transparent,
                                showTitle: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60.h, // Positioned inside the semi-circle
                      left: -50.w,
                      right: -50.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: health,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            fontColor: healthColor,
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                          ),
                          SizedBox(height: 4.h),
                          CustomText(
                            text: _getHealthDescription(health),
                            fontSize: 11.sp,
                            fontColor: colorScheme.outline,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),
            const Divider(),
            SizedBox(height: 15.h),

            // KYC info section
            CustomText(
              text: 'KYC Profile Standing',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontColor: colorScheme.onSurface,
            ),
            SizedBox(height: 6.h),
            CustomText(
              text: 'Update your identification documents below to request verification and improve your standing.',
              fontSize: 13.sp,
              fontColor: colorScheme.outline,
              textAlignment: TextAlign.start,
            ),
            SizedBox(height: 20.h),

            // Identity Document Box
            _buildUploadBox(
              context: context,
              title: 'Identity Document (ID/Passport)',
              url: _identityDocUrl,
              isUploading: _identityDocUploading,
              onTap: _pickIdentityDoc,
            ),
            SizedBox(height: 16.h),

            // Business License Box
            _buildUploadBox(
              context: context,
              title: 'Business License / Permit',
              url: _businessLicenseUrl,
              isUploading: _businessLicenseUploading,
              onTap: _pickBusinessLicense,
            ),
            SizedBox(height: 30.h),

            // Submit Button
            CustomButton(
              label: 'Update KYC Documents',
              textColor: Colors.white,
              buttonWidth: double.infinity,
              backgroundColor: AppColors.orange,
              isLoading: _isSaving,
              onPressed: (_isSaving || _identityDocUploading || _businessLicenseUploading)
                  ? null
                  : _submitKycUpdate,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox({
    required BuildContext context,
    required String title,
    required String? url,
    required bool isUploading,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isUploading ? null : onTap,
      child: Container(
        height: 110.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: url != null ? AppColors.lightOrange.withValues(alpha: 0.2) : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: url != null ? AppColors.orange : colorScheme.outlineVariant,
            style: BorderStyle.solid,
            width: url != null ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: isUploading
              ? SizedBox(
                  height: 24.r,
                  width: 24.r,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.orange),
                )
              : url != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_rounded, color: AppColors.orange, size: 30.sp),
                        SizedBox(height: 6.h),
                        CustomText(
                          text: '$title Uploaded',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          fontColor: colorScheme.onSurface,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: 'Tap to replace file',
                          fontSize: 10.sp,
                          fontColor: colorScheme.outline,
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: colorScheme.outline, size: 28.sp),
                        SizedBox(height: 6.h),
                        CustomText(
                          text: 'Upload $title',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          fontColor: colorScheme.onSurface,
                        ),
                        SizedBox(height: 2.h),
                        CustomText(
                          text: 'Format: JPEG, PNG',
                          fontSize: 10.sp,
                          fontColor: colorScheme.outline,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  String _getHealthDescription(String health) {
    switch (health) {
      case 'Excellent':
        return 'Fully verified with clean history';
      case 'Good':
        return 'Verified with minor warnings';
      case 'Average':
        return 'KYC verification under review';
      default:
        return 'KYC required or account restricted';
    }
  }
}