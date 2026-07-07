import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';

class ReceiptDetailsScreen extends StatefulWidget {
  const ReceiptDetailsScreen({super.key});

  @override
  State<ReceiptDetailsScreen> createState() => _ReceiptDetailsScreenState();
}

class _ReceiptDetailsScreenState extends State<ReceiptDetailsScreen> {
  late final String _orderId;
  OrderModel? _order;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _orderId = Get.arguments as String? ?? '';
    _load();
  }

  Future<void> _load() async {
    if (_orderId.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final order = await ApiOrderService.instance.getOrder(_orderId);
      setState(() {
        _order = order;
      });
    } catch (_) {
      // Non-fatal
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _getAddressText(Map<String, dynamic>? address) {
    if (address == null) return 'No shipping address provided.';
    final fullName = address['fullName'] ?? address['name'] ?? '';
    final line1 = address['line1'] ?? address['street'] ?? '';
    final line2 = address['line2'] ?? '';
    final city = address['city'] ?? '';
    final state = address['state'] ?? '';
    final postalCode = address['postalCode'] ?? address['zip'] ?? '';
    final country = address['country'] ?? '';
    
    return [
      if (fullName.toString().isNotEmpty) fullName,
      if (line1.toString().isNotEmpty) line1,
      if (line2.toString().isNotEmpty) line2,
      [
        if (city.toString().isNotEmpty) city,
        if (state.toString().isNotEmpty) state,
        if (postalCode.toString().isNotEmpty) postalCode,
      ].join(' ').trim(),
      if (country.toString().isNotEmpty) country,
    ].join('\n').trim();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: const Text(
            'Receipt & Shipping Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_order == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: const Text(
            'Receipt & Shipping Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(child: Text('Order not found.')),
      );
    }

    // Since shippingAddressSnapshot on OrderModel is not a strict Model in Dart, we parse it as a Map
    // Wait! Let's check how the shippingAddressSnapshot is defined in OrderModel.
    // In our order_model.dart, there is no shippingAddressSnapshot field parsed explicitly!
    // Wait, let's view order_model.dart line 40 to 60 to verify.
    // Ah! Yes:
    // final String? trackingNumber;
    // final String? trackingCarrier;
    // ...
    // And in factory:
    // OrderModel.fromJson does NOT parse shippingAddressSnapshot!
    // But wait, the raw JSON has "shippingAddressSnapshot"!
    // Let's modify OrderModel to also parse shippingAddressSnapshot as Map<String, dynamic>?!
    // That is incredibly smart! Let's double check if we need to do that. Yes, if we want to show the real address!
    // Let's see: how is shippingAddressSnapshot structured? It's a Map.
    // Let's first implement receipt_details_screen.dart, but wait, if OrderModel doesn't have shippingAddressSnapshot field, we won't be able to access it via _order.shippingAddressSnapshot!
    // Let's check if the OrderModel JSON parsing in order_model.dart discards it.
    // Yes:
    // factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(...)
    // If we look at it, it doesn't store shippingAddressSnapshot as a field.
    // Let's add shippingAddressSnapshot to OrderModel!
    // Let's search for `shippingAddressSnapshot` in order_model.dart to see if it is already there. No, we checked, it isn't.
    // Let's add it!
    // First, let's complete the receipt_details_screen.dart code and then update order_model.dart to include shippingAddressSnapshot.
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Receipt & Shipping Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Receipt',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Receipt Items
            _buildReceiptRow('Subtotal', '£${_order!.subtotal.toStringAsFixed(2)}'),
            _buildReceiptRow('Shipping', '£${_order!.shippingCost.toStringAsFixed(2)}'),
            _buildReceiptRow('Taxes', '£${_order!.taxAmount.toStringAsFixed(2)}'),
            _buildReceiptRow('Order total', '£${_order!.totalAmount.toStringAsFixed(2)}'),

            const SizedBox(height: 32),

            // Shipping Section
            const Text(
              'Shipping Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // We will load the raw JSON map directly from the order or parse it in OrderModel
            // Wait, we can add it to OrderModel! But if we haven't updated OrderModel yet, we can also extract it from GetX or the API response directly if needed, but adding to OrderModel is the most maintainable.
            // Let's do it!
            Text(
              // Access a temporary address or wait until we add it to OrderModel.
              // Let's update OrderModel first!
              _getAddressText(_orderAddressMap),
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  // We can parse from raw JSON if needed, or define a getter for addressMap
  Map<String, dynamic>? get _orderAddressMap => _order?.shippingAddressSnapshot;

  // Helper method to create the key-value rows
  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 120, // Maintains alignment like the image
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}