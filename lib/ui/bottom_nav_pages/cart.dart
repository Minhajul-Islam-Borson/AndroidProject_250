import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/checkout.dart';
import 'package:flutter_ecommerce/ui/product_details_screen.dart';
import '../bottom_nav_controller.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Cart Items"),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BottomNavController()),
                );
              }
            },
          ),
        ),
        body: const Center(child: Text("Please log in to see your cart.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Items"),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const BottomNavController()),
              );
            }
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users-cart-items")
            .doc(userEmail)
            .collection("items")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong."));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Your cart is empty."));
          }

          final cartDocs = snapshot.data!.docs;

          // Prepare data for checkout screen
          int totalItems = cartDocs.length;
          double totalPrice = 0;
          List<Map<String, dynamic>> checkoutItems = [];

          for (var doc in cartDocs) {
            final data = doc.data() as Map<String, dynamic>;
            final price = double.tryParse(data['price'].toString()) ?? 0;
            final qty = data['qty'] ?? 1;
            totalPrice += price * qty;

            checkoutItems.add({
              'name': data['name'],
              'price': price,
              'qty': qty,
              'imgUrl': (data['images'] != null && data['images'].isNotEmpty)
                  ? data['images'][0]
                  : '',
            });
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartDocs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot = cartDocs[index];
                    final data =
                        documentSnapshot.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen({
                              "product-name": data['name'],
                              "product-price": data['price'],
                              "product-img": data['images'],
                              "product-description": data['description'] ?? "",
                            }),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        elevation: 3,
                        child: ListTile(
                          leading: data['images'] != null &&
                                  data['images'].isNotEmpty
                              ? Image.network(
                                  data['images'][0],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(data['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("৳ ${data['price']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection("users-cart-items")
                                  .doc(userEmail)
                                  .collection("items")
                                  .doc(documentSnapshot.id)
                                  .delete();
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              //Total + Continue to Checkout Button
              SafeArea(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    //boxShadow: [
                    //BoxShadow(color: Colors.black12, blurRadius: 5)
                    //],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Items: $totalItems",
                              style: const TextStyle(fontSize: 16)),
                          Text("Total: ৳${totalPrice.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to CheckoutScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  cartItems: checkoutItems,
                                  totalPrice: totalPrice,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text("Continue to Checkout",
                              style: TextStyle(fontSize: 16,color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
