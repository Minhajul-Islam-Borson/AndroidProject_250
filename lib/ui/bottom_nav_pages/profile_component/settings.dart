import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  updateData() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("user-form-data")
          .doc(userEmail)
          .update({
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "age": _ageController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating profile: $e")),
      );
    }
  }

  Widget buildForm(Map<String, dynamic> data) {
    _nameController.text = data['name'] ?? '';
    _phoneController.text = data['phone'] ?? '';
    _ageController.text = data['age'] ?? '';

    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: "Phone"),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(labelText: "Age"),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: updateData,
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail == null) {
      return Scaffold(
        body: Center(child: Text("No user is logged in.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("user-form-data")
                .doc(userEmail)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text("No profile data found."));
              }

              final data = snapshot.data!.data() as Map<String, dynamic>;
              return buildForm(data);
            },
          ),
        ),
      ),
    );
  }
}
