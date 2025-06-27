import 'package:flutter/material.dart';

class Policies extends StatelessWidget {
  const Policies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const Text(
          '''Privacy Policy

We value your privacy. This Privacy Policy explains how we collect, use, and protect your information.

Information We Collect:
- Name, email address, phone number
- Shipping address and order history
- Payment method (e.g., bKash) - we do not store card or bKash PINs

Why We Collect Data:
- To process and deliver your orders
- To contact you about your orders or updates
- To improve user experience

We do not sell or share your data with third parties. Your information is stored securely.

If you have any questions, please contact us at support@example.com
''',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
