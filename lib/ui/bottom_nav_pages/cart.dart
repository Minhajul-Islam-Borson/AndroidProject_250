import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          title: Text("Cart Items"),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => BottomNavController()),
                );
              }
            },
          ),
        ),
        body: Center(child: Text("Please log in to see your cart.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Items"),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => BottomNavController()),
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users-cart-items")
              .doc(userEmail)
              .collection("items")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("This cart is Empty"),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Something is wrong"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];

                // FIXED: Use .data() to get document data as a Map
                final data = documentSnapshot.data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen({
                          "product-name": data['name'],
                          "product-price": data['price'],
                          "product-img": data['images'], // list of image URLs
                          // FIXED: Check if 'description' key exists before accessing
                          "product-description":
                          data.containsKey('description') ? data['description'] : "",
                        }),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 4,
                    child: ListTile(
                      leading: data['images'] != null && data['images'].isNotEmpty
                          ? Image.network(
                        data['images'][0],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                      )
                          : const Icon(Icons.image_not_supported),
                      title: Text(
                        data['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
            );
          },
        ),
      ),
    );
  }
}
