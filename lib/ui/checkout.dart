import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_controller.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String _address = '';
  String _paymentMethod = 'Cash on Delivery';
  bool _isSubmitting = false;

  // === CHANGED ===
  // Fetch phone number from 'user-form-data' collection instead of 'users'
  Future<String?> _getUserPhoneNumber(String email) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('user-form-data')
        .doc(email)
        .get();
    return docSnapshot.data()?['phone'];
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSubmitting = true);

    final userEmail = FirebaseAuth.instance.currentUser!.email!;

    // === CHANGED ===
    // Get phone from user-form-data collection
    final userPhone = await _getUserPhoneNumber(userEmail);

    final orderData = {
      'items': widget.cartItems,
      'total': widget.totalPrice,
      'address': _address,
      'phone': userPhone ?? '', // Use phone from Firestore
      'payment': _paymentMethod,
      'status': 'pending',
      'email': userEmail,
      'timestamp': FieldValue.serverTimestamp(),
    };

    final docRef =
        await FirebaseFirestore.instance.collection('orders').add(orderData);

    // Clear user cart
    final cartCol = FirebaseFirestore.instance
        .collection('users-cart-items')
        .doc(userEmail)
        .collection('items');
    final cartSnapshot = await cartCol.get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    setState(() => _isSubmitting = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrderConfirmationScreen(orderId: docRef.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      bottomNavigationBar: _isSubmitting
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _placeOrder,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Place Order',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ),
      body: _isSubmitting
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address input field remains
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Shipping Address',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                        onSaved: (v) => _address = v!.trim(),
                      ),
                      const SizedBox(height: 16),

                      // Removed phone number input from UI
                      // because phone will be auto fetched from Firestore

                      ExpansionTile(
                        title: Text(
                            'Order Summary (${widget.cartItems.length} items)'),
                        children: [
                          ...widget.cartItems.map((item) {
                            return ListTile(
                              leading: Image.network(item['imgUrl'],
                                  width: 40, height: 40, fit: BoxFit.cover),
                              title: Text(item['name']),
                              subtitle: Text('Qty: ${item['qty']}'),
                              trailing: Text(
                                  '৳ ${(item['price'] * item['qty']).toStringAsFixed(2)}'),
                            );
                          }).toList(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    '৳ ${widget.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: _paymentMethod,
                        decoration: const InputDecoration(
                          labelText: 'Payment Method',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'Cash on Delivery',
                              child: Text('Cash on Delivery')),
                          DropdownMenuItem(
                              value: 'Bkash', child: Text('Bkash')),
                        ],
                        onChanged: (v) =>
                            setState(() => _paymentMethod = v ?? ''),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  const OrderConfirmationScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmed')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text('Thank you for your order!',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Order ID: $orderId'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavController()),
                );
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
