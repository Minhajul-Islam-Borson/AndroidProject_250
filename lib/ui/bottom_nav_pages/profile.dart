import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/profile_component/my_location.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/profile_component/settings.dart'as my_settings;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../bottom_nav_controller.dart';
import '../login_screen.dart';

class Profile extends StatelessWidget {
  final Widget? previousPage;
  const Profile({super.key, this.previousPage});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Account",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const my_settings
                        .Settings()), //Open Settings from AppBar
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userEmail == null
                  ? _buildGuestProfile()
                  : StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("user-form-data")
                          .doc(userEmail)
                          .snapshots(),
                      builder: (context, snapshot) {
                        String name = "Guest User";
                        if (snapshot.hasData && snapshot.data!.exists) {
                          final data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          name = data['name'] ?? name;
                        }
                        return _buildProfileCard(name, userEmail);
                      },
                    ),

              const SizedBox(height: 20),
              const Text("My Orders",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              _buildOrderTile(Icons.inventory_2_outlined, "All Orders"),
              _buildOrderTile(Icons.my_location, "My Location", onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyLocation()),
                );
              }),
              _buildOrderTile(Icons.payment, "Payment Method"),

              _buildOrderTile(Icons.settings, "Settings", onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const my_settings.Settings()),
                );
              }),

              const SizedBox(height: 10),

              //Login/Sign Out logic
              userEmail == null
                  ? _buildOrderTile(Icons.login, "Login", onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    })
                  : _buildOrderTile(Icons.logout, "Sign Out", onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Sign Out"),
                          content:
                              const Text("Are you sure you want to sign out?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const BottomNavController()),
                                  (route) => false,
                                );
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );
                    }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestProfile() {
    return _buildProfileCard("Guest User", "Not logged in");
  }

  Widget _buildProfileCard(String name, String? email) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              "https://cdn.pixabay.com/photo/2024/02/15/16/57/cat-8575768_1280.png",
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              Text(email ?? '', style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Your Account"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTile(IconData icon, String title, {VoidCallback? onTap}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
