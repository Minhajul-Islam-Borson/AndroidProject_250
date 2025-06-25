import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/cart.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/favourite.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_pages/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'bottom_nav_pages/home_page1.dart';
class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  var _page=0;
  final pages= [HomePage1(),Favourite(),Cart(),Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.blue,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index){
              setState(() {
                _page=index;
                //Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context)=> pages[index]));
                //pages[_page]=Profile(previousPage: pages[_page],);
              });
          },
          items:[
            Icon(Icons.home),
            Icon(Icons.favorite),
            Icon(Icons.add_shopping_cart),
            Icon(Icons.person),
          ] ,
      ),
      body: pages[_page],
    );
  }
}
