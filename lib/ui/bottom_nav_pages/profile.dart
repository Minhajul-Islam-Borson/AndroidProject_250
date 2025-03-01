import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final Widget? previousPage;
  const Profile({super.key,this.previousPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        //elevation: 0,
        title: Text("Account", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if(previousPage!=null){
              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=>previousPage!));
            }
            else{
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            Container(
              padding: EdgeInsets.all(12),
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
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2024/02/15/16/57/cat-8575768_1280.png"),
                    //backgroundImage: AssetImage("images/Borson.JPG"),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Minhajul Islam Borson", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("minhajulborson@gmail.com", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("3 Points", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text("My Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildOrderTile(Icons.inventory_2_outlined, "All Orders"),
            _buildOrderTile(Icons.autorenew, "Processing"),
            _buildOrderTile(Icons.local_shipping, "Shipped"),
            _buildOrderTile(Icons.assignment_return, "Return"),
            _buildOrderTile(Icons.payment, "Payment Method"),
            _buildOrderTile(Icons.settings, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTile(IconData icon, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}