import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/widgets/custom_button.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../controllers/auth_controller.dart';

class CheckEmailScreen extends StatefulWidget {
  const CheckEmailScreen({super.key});

  @override
  State<CheckEmailScreen> createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final List<TextEditingController> _digitControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _digitControllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Handle paste arriving in a single box
      final digits = value.replaceAll(RegExp(r'\D'), '').characters.take(6).toList();
      for (int i = 0; i < digits.length && i < 6; i++) {
        _digitControllers[i].text = digits[i];
      }
      final nextFocus = (digits.length < 6) ? digits.length : 5;
      _focusNodes[nextFocus].requestFocus();
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _digitControllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verify() {
    final code = _otpCode;
    if (code.length < 6) {
      Get.snackbar(
        'Enter code',
        'Please enter all 6 digits.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    _authController.verifyResetOtp(code);
  }

  void _resend() {
    final email = _authController.pendingEmail.value;
    if (email.isNotEmpty) {
      for (final c in _digitControllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
      _authController.forgotPassword(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 31.w),
          child: Obx(() {
            final email = _authController.pendingEmail.value;
            final isLoading = _authController.isLoading.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBoxWidget(height: 25),
                SvgPicture.asset(
                  Assets.icons.grCheckEmail,
                  width: 240.w,
                  height: 238.h,
                ),
                SizedBoxWidget(height: 15),
                CustomText(
                  text: 'Check your email',
                  fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
                SizedBoxWidget(height: 8),
                Text(
                  'We sent a 6-digit code to',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 14.sp,
                  ),
                ),
                if (email.isNotEmpty) ...[
                  SizedBoxWidget(height: 4),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                SizedBoxWidget(height: 28),

                // ── OTP digit boxes ───────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (i) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: KeyboardListener(
                        focusNode: FocusNode(skipTraversal: true),
                        onKeyEvent: (e) => _onKeyEvent(i, e),
                        child: SizedBox(
                          width: 44.w,
                          height: 52.h,
                          child: TextField(
                            controller: _digitControllers[i],
                            focusNode: _focusNodes[i],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: colorScheme.onSurface.withValues(alpha: 0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                  color: colorScheme.onSurface.withValues(alpha: 0.2),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(
                                  color: colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (v) => _onDigitChanged(i, v),
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                SizedBoxWidget(height: 24),
                CustomButton(
                  label: isLoading ? 'Verifying…' : 'Verify code',
                  fontWeight: FontWeight.w700,
                  buttonHeight: 40.h,
                  onPressed: isLoading ? null : _verify,
                ),
                SizedBoxWidget(height: 15),

                // ── Resend ────────────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive it?  ",
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                      ),
                    ),
                    GestureDetector(
                      onTap: isLoading ? null : _resend,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_rounded, color: colorScheme.primary),
                      SizedBoxWidget(width: 8),
                      CustomText(
                        text: 'Back',
                        fontColor: colorScheme.primary,
                        fontSize: 14.sp,
                      ),
                    ],
                  ),
                ),
                SizedBoxWidget(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }
}
