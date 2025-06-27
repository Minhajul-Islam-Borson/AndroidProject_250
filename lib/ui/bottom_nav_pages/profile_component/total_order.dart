import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TotalOrderScreen extends StatefulWidget {
  const TotalOrderScreen({super.key});

  @override
  State<TotalOrderScreen> createState() => _TotalOrderScreenState();
}

class _TotalOrderScreenState extends State<TotalOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Your Orders")),
        body: const Center(child: Text("Please log in to see your orders.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('email', isEqualTo: userEmail)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error loading orders: ${snapshot.error}');
            return Center(
              child: Text('Error loading orders: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final doc = orders[index];
              final data = doc.data()! as Map<String, dynamic>;

              final List<dynamic> items = data['items'] ?? [];
              final total = data['total'] ?? 0;
              final address = data['address'] ?? '';
              final phone = data['phone'] ?? '';
              final payment = data['payment'] ?? '';
              final status = data['status'] ?? '';
              final timestamp = data['timestamp'] as Timestamp?;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                child: ExpansionTile(
                  title: Text(
                      'Order #${doc.id.substring(0, 8)} - ₹${total.toStringAsFixed(2)}'),
                  subtitle: Text('Status: $status\nPayment: $payment'),
                  children: [
                    ListTile(
                      title: const Text('Shipping Address'),
                      subtitle: Text(address),
                    ),
                    ListTile(
                      title: const Text('Phone Number'),
                      subtitle: Text(phone),
                    ),
                    ListTile(
                      title: const Text('Order Date'),
                      subtitle: Text(timestamp != null
                          ? timestamp.toDate().toString()
                          : 'No date'),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Items:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ...items.map((item) {
                      return ListTile(
                        leading: item['imgUrl'] != null
                            ? Image.network(item['imgUrl'],
                                width: 40, height: 40, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                        title: Text(item['name'] ?? 'No name'),
                        subtitle: Text('Qty: ${item['qty'] ?? 0}'),
                        trailing: Text(
                            '৳ ${(item['price'] * (item['qty'] ?? 0)).toStringAsFixed(2)}'),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
