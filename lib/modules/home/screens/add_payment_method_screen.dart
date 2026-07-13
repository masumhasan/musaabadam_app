import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_payment_service.dart';
import '../../../core/assets_gen/assets.gen.dart';

class AddPaymentMethodScreen extends StatelessWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Payment Method',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildPaymentOption(
                  iconPath: Assets.images.creditCard.keyName,
                  label: 'Credit/Debit Card',
                  onTap: () async {
                    final success = await showDialog<bool>(
                      context: context,
                      builder: (context) => const _CardInputDialog(),
                    );
                    if (success == true) {
                      Navigator.pop(context); // Go back to payment methods list
                    }
                  },
                ),
                _buildPaymentOption(
                  iconPath: Assets.images.googleApplePay.keyName,
                  label: 'Google/Apple Pay',
                  onTap: () {
                    Get.snackbar('Info', 'Google/Apple Pay is currently unavailable. Please use a credit or debit card.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                ),
                _buildPaymentOption(
                  iconPath: Assets.images.paypal.keyName,
                  label: 'Paypal',
                  onTap: () {
                    Get.snackbar('Info', 'PayPal is currently unavailable. Please use a credit or debit card.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                ),
                _buildPaymentOption(
                  iconPath: Assets.images.klarna.keyName,
                  label: 'Klarna',
                  onTap: () {
                    Get.snackbar('Info', 'Klarna is currently unavailable. Please use a credit or debit card.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                ),
              ],
            ),
          ),
          _buildBottomButtons(context),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Image.asset(iconPath, width: 30, height: 30),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardInputDialog extends StatefulWidget {
  const _CardInputDialog();

  @override
  State<_CardInputDialog> createState() => _CardInputDialogState();
}

class _CardInputDialogState extends State<_CardInputDialog> {
  final _holderCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _holderCtrl.dispose();
    _numberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final number = _numberCtrl.text.replaceAll(' ', '').trim();
    final holder = _holderCtrl.text.trim();
    final expiry = _expiryCtrl.text.trim();
    final cvv = _cvvCtrl.text.trim();

    if (number.isEmpty || expiry.isEmpty || cvv.isEmpty) {
      Get.snackbar('Input Error', 'Please fill in all card details.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Parse expiry MM/YY
    final parts = expiry.split('/');
    int month = 12;
    int year = 2030;
    if (parts.length == 2) {
      month = int.tryParse(parts[0]) ?? 12;
      final shortYear = int.tryParse(parts[1]) ?? 30;
      year = 2000 + shortYear;
    } else {
      Get.snackbar('Input Error', 'Expiry date must be in MM/YY format.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Auto detect brand
    String brand = 'visa';
    if (number.startsWith('5')) {
      brand = 'mastercard';
    } else if (number.startsWith('3')) {
      brand = 'amex';
    } else if (number.startsWith('6')) {
      brand = 'discover';
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await ApiPaymentService.instance.addMethod(
        card: {
          'number': number,
          'brand': brand,
          'expMonth': month,
          'expYear': year,
        },
        makeDefault: true,
      );
      Get.snackbar('Success', 'Card added successfully.',
          snackPosition: SnackPosition.BOTTOM);
      Navigator.of(context).pop(true); // Return true on success
    } on DioException catch (e) {
      Get.snackbar('Error', ApiPaymentService.extractError(e),
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: const Color(0xFFE0EBEF), // Light blue-grey background
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Add your payment information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              _buildInputField('Card Holder Name', 'Kathryn Murphy', _holderCtrl, false),
              const SizedBox(height: 16),

              _buildInputField('Card Number', '4242 4242 4242 4242', _numberCtrl, true),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildInputField('Expiry Date', '12/29', _expiryCtrl, true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInputField('CVV', '123', _cvvCtrl, true)),
                ],
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isSaving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0089A7), // Teal color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController controller, bool isNumber) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4DA8C0), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0089A7), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}