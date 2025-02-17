import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Flutter E-Commerce App",
          home: SplashScreen(),
        );
      },
    );
  }
}



