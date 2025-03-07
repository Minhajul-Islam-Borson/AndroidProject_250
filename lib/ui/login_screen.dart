import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_ecommerce/ui/bottom_nav_controller.dart';
import 'package:flutter_ecommerce/ui/home_screen.dart';
import 'package:flutter_ecommerce/ui/registration_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText =true;
  singIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
      );
      var authCredential = userCredential.user;
      print(authCredential!.uid);
      if(authCredential.uid.isNotEmpty){
        Navigator.push(context, CupertinoPageRoute(builder: (context)=>BottomNavController()));
      }
      else{
        Fluttertoast.showToast(msg: "Something is wrong");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //print('No user found for that email.');
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        //print('Wrong password provided for that user.');
        Fluttertoast.showToast(msg: "Wrong password provided for that user.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 150.h,
                width: ScreenUtil().screenWidth,
                child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(onPressed: null, icon: Icon(Icons.light,color: Colors.transparent,)),
                      Text("Sign In", style: TextStyle(fontSize: 22.sp,color: Colors.white),),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28.r),
                        topRight: Radius.circular(28.r),
                      )
                    ),
                    child: Padding(
                        padding: EdgeInsets.all(20.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Text("Welcome Back", style: TextStyle(fontSize: 22.sp,color: AppColors.orange),),
                            Text("Glad to see you my buddy!",style: TextStyle(fontSize: 14.sp,color: Color(0xFFBBBBBB) ),),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 41.w,
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.orange,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Center(
                                    child: Icon(
                                        Icons.email_outlined,
                                      color: Colors.white,
                                      size: 20.w,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Expanded(
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: "minhajulborson@gmail.com",
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Color(0xFF414041),
                                        ),
                                        labelText: 'EMAIL',
                                        labelStyle: TextStyle(
                                        fontSize: 15.sp,
                                        color: AppColors.orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            Row(
                              children: [
                                Container(
                                  height: 48.h,
                                  width: 41.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.orange,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Center(
                                    child: Icon(Icons.lock_outline,color: Colors.white,size: 20.w,),
                                  ),
                                ),
                                SizedBox(width: 10.w,),
                                Expanded(
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    decoration: InputDecoration(
                                        hintText: "password must be 6 letter",
                                        hintStyle: TextStyle(
                                          fontSize: 14.sp,
                                          color:  Color(0xFF414041),
                                        ),
                                        labelText: 'Password',
                                        labelStyle: TextStyle(
                                          fontSize: 15.sp,
                                          color: AppColors.orange,
                                        ),
                                        suffixIcon: _obscureText==true?IconButton(
                                            onPressed: (){
                                              setState(() {
                                                _obscureText=false;
                                              });
                                            },
                                            icon: Icon(Icons.remove_red_eye,size: 20.w,))
                                            :IconButton(
                                          onPressed: (){
                                            setState(() {
                                              _obscureText= true;
                                            });
                                          },
                                          icon: Icon(Icons.visibility_off,size: 20.w,),
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50.h,),
                            ElevatedButton(
                                onPressed: (){
                                  //singIn();
                                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>BottomNavController()));
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 10,
                                  backgroundColor: AppColors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  minimumSize: Size(double.infinity,50.h),
                                ),
                                child: Text("Sing In", style: TextStyle(fontSize: 16.sp,color: Colors.white),)
                            ),
                            SizedBox(height: 20.h,),
                            Center(
                              child: Wrap(
                                children: [
                                  Text("Don't have account?", style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600,color:Color(0xFFBBBBBB), ),),
                                  GestureDetector(
                                    child: Text("Sing Up",style: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600,color: AppColors.orange),),
                                    onTap: (){
                                      Navigator.push(context, CupertinoPageRoute(builder: (context)=>RegistrationScreen()));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ],
          ),
      ),
    );
  }
}
