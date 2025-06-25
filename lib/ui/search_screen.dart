import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce/ui/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              onChanged: (val) {
                setState(() {
                  inputText = val;
                  //print(inputText);
                });
              },
              decoration: InputDecoration(
                hintText: "Search here",
              ),
            ),
            Expanded(
              child: Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .orderBy("search-name")
                        .where("search-name",
                            isGreaterThanOrEqualTo: inputText.toLowerCase())
                        .where("search-name",isLessThan: '${inputText.toLowerCase()}z')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something is Wrong"),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading"),
                        );
                      }
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return GestureDetector(
                            //onTap: ()=>Navigator.push(context, CupertinoPageRoute(builder: (context)=>ProductDetailsScreen())),
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(data['product-name']),
                                leading: Image.network(data['product-img'][0]),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
