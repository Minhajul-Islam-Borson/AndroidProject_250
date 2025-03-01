import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBjH0s-3IgWTMy6pZ-ZyJCcc06P1SfRgQk",
            authDomain: "flutter-e-commerce-85581.firebaseapp.com",
            projectId: "flutter-e-commerce-85581",
            storageBucket: "flutter-e-commerce-85581.appspot.com",
            messagingSenderId: "405923799388",
            appId: "1:405923799388:web:5Oddeed4d8222119f26199",
            measurementId: "G-C4KRJREKE7")
    );
  }
  else{
    await Firebase.initializeApp();
  }
  
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



