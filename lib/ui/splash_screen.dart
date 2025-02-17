import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_ecommerce/ui/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState(); // Fix: Call super.initState() first

    // Fix: Use Navigator.pushReplacement to replace the splash screen with the login screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("E-Commerce", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold ,fontSize: 44.sp),),
            SizedBox(height: 10,),
            Container(
              height: 200,
              width: 200,
              child: Card(
                elevation: 10,
                child: Image.asset("images/app_logo.png"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
