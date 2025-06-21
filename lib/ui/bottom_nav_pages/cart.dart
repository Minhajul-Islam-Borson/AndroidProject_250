import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/product_details_screen.dart';

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
        body: Center(child: Text("Please log in to see your cart.")),
      );
    }

    return Scaffold(
      //backgroundColor: Colors.amber,
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
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];

                // FIXED: Use .data() to get document data as a Map
                final data = _documentSnapshot.data() as Map<String, dynamic>;

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
                    elevation: 5,
                    child: ListTile(
                      leading: Text(data['name']),
                      title: Text(
                        "\৳ ${data['price']}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      trailing: GestureDetector(
                        child: const CircleAvatar(
                          child: Icon(Icons.remove_circle),
                        ),
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("users-cart-items")
                              .doc(userEmail)
                              .collection("items")
                              .doc(_documentSnapshot.id)
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
