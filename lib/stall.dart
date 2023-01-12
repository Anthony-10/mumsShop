import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class BoughtView extends StatefulWidget {
  const BoughtView({Key? key}) : super(key: key);

  @override
  _BoughtViewState createState() => _BoughtViewState();
}

class _BoughtViewState extends State<BoughtView> {
  final blogPostController = Get.put(BlogPostController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30, left: 100, bottom: 20),
              child: Container(
                  child: const Text(
                'Bought',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("ShopItems")
                        /*.where("Categories",
                            isEqualTo: blogPostController.itemCategories.value)*/
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text("Check your connection"),
                          );
                        } else {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data?.size,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: 150,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                height: 120,
                                                width: 100,
                                                child: Card(
                                                  child: CachedNetworkImage(
                                                    /*cacheManager: buyController
                                                        .customCacheManager,*/
                                                    imageUrl: snapshot.data
                                                        ?.docs[index]['Url'],
                                                    fit: BoxFit.fill,
                                                    placeholder:
                                                        (context, url) =>
                                                            Container(
                                                      color: Colors.black12,
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Container(
                                                      color: Colors.black12,
                                                      child: const Icon(
                                                          Icons.error,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  semanticContainer: true,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  elevation: 20.0,
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Categories: ${snapshot.data?.docs[index]['Categories'].toString()}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Price: ${snapshot.data?.docs[index]['Price'].toString()}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'initialPrice: ${snapshot.data?.docs[index]['initialPrice'].toString()}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  /* Text(
                                                      'Amount: ${snapshot.data?.docs[index]['amount'].toString()}'),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),*/
                                                  Text(
                                                    'Date: ${snapshot.data?.docs[index]['Date'].toString()}',
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }
                        }
                        return const Text('Loading....');
                      } else {
                        return const Text('Loading....');
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
