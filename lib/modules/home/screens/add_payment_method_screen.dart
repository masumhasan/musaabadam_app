import 'package:flutter/material.dart';

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
                  onTap: () {
                    showMethodDialog(context);
                  },
                ),
                _buildPaymentOption(
                  iconPath: Assets.images.googleApplePay.keyName,
                  label: 'Google/Apple Pay',
                  onTap: () {
                    showMethodDialog(context);
                  },
                ),
                _buildPaymentOption(
                  iconPath: Assets.images.paypal.keyName,
                  label: 'Paypal',
                  onTap: () {
                    showMethodDialog(context);
                  },
                ),
                _buildPaymentOption(
                  iconPath: Assets.images.klarna.keyName,
                  label: 'Klarna',
                  onTap: () {
                    showMethodDialog(context);
                  },
                ),
              ],
            ),
          ),
          _buildBottomButtons(),
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

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD9E9F2), // Light blue color
                foregroundColor: const Color(0xFF007BFF), // Text color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 15),
                elevation: 0,
              ),
              child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void showMethodDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: const Color(0xFFE0EBEF), // Light blue-grey background
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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

                _buildInputField('Card Holder Name', 'Kathryn Murphy'),
                const SizedBox(height: 16),

                _buildInputField('Card Number', '000 000 000 67'),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: _buildInputField('Expiry Date', '04/28')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInputField('CVV', '0000')),
                  ],
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0089A7), // Teal color
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
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
        );
      },
    );
  }

  Widget _buildInputField(String label, String hint) {
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