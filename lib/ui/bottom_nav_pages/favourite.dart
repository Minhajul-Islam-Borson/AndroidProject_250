import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/product_details_screen.dart';
import '../bottom_nav_controller.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    // Safety check in case user is not logged in
    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Favourite Items"),
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
        body: Center(child: Text("Please log in to see your favourites.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Favourite Items"),
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
              .collection("users-favourite-items")
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
                child: Text("No favourite items found."),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong."),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];

                // Get document data safely
                final data = documentSnapshot.data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen({
                          "product-name": data['name'],
                          "product-price": data['price'],
                          "product-img": data['images'],
                          // Check for optional description
                          "product-description":
                          data.containsKey('description') ? data['description'] : "",
                        }),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: data['images'] != null && data['images'].isNotEmpty
                          ? Image.network(
                        data['images'][0],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                          : Icon(Icons.image_not_supported),
                      title: Text(
                        data['name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("৳ ${data['price']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("users-favourite-items")
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
