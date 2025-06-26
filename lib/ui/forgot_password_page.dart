import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }
  
  Future passwordReset()async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Password reset link sent. Check you email."),
            backgroundColor: Colors.green,
          ),
      );
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "An error occured"),
          backgroundColor: Colors.red,
        ),
      );
    }

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 1,
      ),
      body: Column(
          children: [
            Text("Reset you password",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Container(
                    width: 41.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
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
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: ElevatedButton(
                  onPressed: (){
                    passwordReset();
                    //signIn();
                    //Navigator.push(context, CupertinoPageRoute(builder: (context)=>BottomNavController()));
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    minimumSize: Size(double.infinity,50.h),
                  ),
                  child: Text("Reset Password", style: TextStyle(fontSize: 16.sp,color: Colors.white),)
              ),
            ),
          ],
      ),
    );
  }
}
