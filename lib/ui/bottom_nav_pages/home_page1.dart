import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/const/AppColors.dart';
import 'package:flutter_ecommerce/ui/product_details_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../search_screen.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({super.key});

  @override
  State<HomePage1> createState() => _HomePage1State();
}

class _HomePage1State extends State<HomePage1> {
  final TextEditingController _searchController = TextEditingController();

  List<String> _carouselImages = [];
  var _dotPosition = 0;
  final List<Map<String, dynamic>> _products = [];
  final _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn = await _firestoreInstance.collection("home-slider").get();

    setState(() {
      _carouselImages =
          qn.docs.map((doc) => doc["img-path"] as String).toList();
    });
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-price": qn.docs[i]["product-price"],
          "product-img": qn.docs[i]["product-img"],
        });
      }
    });

    return qn.docs;
  }

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
    fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = _carouselImages.isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (_) => SearchScreen()),
                        );
                      },
                      child: AbsorbPointer(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 18.h, horizontal: 15.w),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: "Search Product Here",
                              hintStyle: TextStyle(fontSize: 15.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        color: AppColors.orange,
                        height: 60.h,
                        width: 50.w,
                        child: Center(
                          child: Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SearchScreen()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              AspectRatio(
                aspectRatio: 3.5,
                child: hasImages
                    ? CarouselSlider(
                        items: _carouselImages
                            .map(
                              (item) => Padding(
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
                              ),
                            )
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
                  dotsCount: hasImages ? _carouselImages.length : 1,
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
                "View Product",
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: GridView.builder(
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailsScreen(_products[index]),
                          ),
                        ),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, //added
                            children: [
                              AspectRatio(
                                aspectRatio: 1.2,
                                child: Container(
                                  color: Colors.orange,
                                  child: Image.network(
                                    _products[index]["product-img"][0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 4),
                                child: Text(
                                  "${_products[index]["product-name"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  "৳${_products[index]["product-price"].toString()}",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                  maxLines: 1, 
                                  overflow: TextOverflow.ellipsis, 
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
