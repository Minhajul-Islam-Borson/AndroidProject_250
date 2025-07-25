import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const/AppColors.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> _product;
  const ProductDetailsScreen(this._product, {super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _dotPosition = 0;

  //add null check for currentUser before adding to cart
  Future addToCart() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;

    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "Please log in to add items to cart.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.sp,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-cart-items");

    return collectionRef.doc(currentUser.email).collection("items").doc().set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "images": widget._product["product-img"],
    }).then((value) => Fluttertoast.showToast(
          msg: "Product added to cart",
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.sp,
          toastLength: Toast.LENGTH_LONG,
        ));
  }

  //add null check for currentUser before adding to favourite
  Future addToFavourite() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;

    if (currentUser == null) {
      Fluttertoast.showToast(
        msg: "Please log in to add items to favourite.",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.sp,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-items");

    return collectionRef.doc(currentUser.email).collection("items").doc().set({
      "name": widget._product["product-name"],
      "price": widget._product["product-price"],
      "images": widget._product["product-img"],
    }).then((value) => Fluttertoast.showToast(
          msg: "Product added to favourite",
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.sp,
          toastLength: Toast.LENGTH_LONG,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget._product['product-img'] != null &&
        widget._product['product-img'].isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.orange,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        actions: [
          //check if user is logged in before using currentUser!.email
          Builder(builder: (context) {
            var currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
              // User not logged in - show nothing or a disabled icon
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.7),
                  child: IconButton(
                    icon: Icon(Icons.favorite_outline, color: Colors.white),
                    onPressed: () async {
                      await addToFavourite();
                      // Fluttertoast.showToast(
                      //   msg: "Please log in first to add to favourite",
                      //   backgroundColor: Colors.red,
                      //   textColor: Colors.white,
                      //   fontSize: 16.sp,
                      //   toastLength: Toast.LENGTH_LONG,
                      // );
                      // Navigator.push(context, CupertinoPageRoute(builder: (_) => LoginScreen()));
                    },
                  ),
                ),
              );
            }

            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users-favourite-items")
                  .doc(currentUser.email)
                  .collection("items")
                  .where("name", isEqualTo: widget._product['product-name'])
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: IconButton(
                      onPressed: snapshot.data.docs.length == 0
                          ? () => addToFavourite()
                          : () => Fluttertoast.showToast(
                                msg: "Already added to favourite",
                                backgroundColor: Colors.blueAccent,
                                textColor: Colors.white,
                                fontSize: 16.sp,
                                toastLength: Toast.LENGTH_LONG,
                              ),
                      icon: snapshot.data.docs.length == 0
                          ? Icon(Icons.favorite_outline, color: Colors.white)
                          : Icon(Icons.favorite, color: Colors.white),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 2,
                child: hasImages
                    ? CarouselSlider(
                        items: widget._product['product-img']
                            .map<Widget>((item) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ))
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.8,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                          onPageChanged: (val, _) {
                            setState(() {
                              _dotPosition = val;
                            });
                          },
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
              SizedBox(height: 10.h),
              Center(
                child: DotsIndicator(
                  dotsCount:
                      hasImages ? widget._product['product-img'].length : 1,
                  position: hasImages ? _dotPosition.toDouble() : 0.0,
                  decorator: DotsDecorator(
                    activeColor: AppColors.orange,
                    color: AppColors.orange.withOpacity(0.5),
                    spacing: EdgeInsets.all(2),
                    activeSize: Size(8, 8),
                    size: Size(6, 6),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Product Name:  ${widget._product['product-name']}",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                "Price ৳${widget._product['product-price'].toString()}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.red),
              ),
              SizedBox(height: 5.h),
              Text(
                "Product Description:  ${widget._product['product-description']}",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 25.h),
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () => addToCart(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              elevation: 3,
            ),
            child: Text(
              "Add to Cart",
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            ),
          ),
        ),
      ),
    );
  }
}
