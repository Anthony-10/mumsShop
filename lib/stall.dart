import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'controller.dart';

class BoughtView extends StatefulWidget {
  const BoughtView({Key? key}) : super(key: key);

  @override
  _BoughtViewState createState() => _BoughtViewState();
}

class _BoughtViewState extends State<BoughtView> {
  final blogPostController = Get.put(BlogPostController());
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 100, bottom: 20),
              child: Container(
                  child: const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              )),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore.collection("Categories").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Check your connection"),
                      );
                    } else {
                      if (snapshot.hasData) {
                        return Container(
                          height: 80,
                          width: Get.width,
                          child: ListView.builder(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.size,
                            itemBuilder: (BuildContext context, int index) {
                              final categories =
                                  snapshot.data?.docs[index]['Item'];
                              return Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        //TODO
                                        blogPostController.item.value =
                                            categories;
                                      });
                                    },
                                    /* child: Container(
                              height: 30,
                              width: 90,
                              child: ChoiceChip(
                                  label: Text(categories.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17)),
                                  selectedColor: Colors.blue,
                                  selected: _isSelected,
                                  onSelected: (newBoolValue) {
                                    setState(() {
                                      return _isSelected = newBoolValue;
                                    });
                                  }),
                            ),*/
                                    child: Container(
                                      height: Get.height * .06,
                                      width: Get.width * .3,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: Get.width * .01,
                                            right: Get.width * .01),
                                        child: Center(
                                            child: Text(categories.toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17))),
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                    }
                    return Text("Loading....");
                  } else {
                    return Container(
                        height: 80,
                        width: Get.width,
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: Get.height * .06,
                                  width: Get.width * .3,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                              ],
                            );
                          },
                        ));
                  }
                }),
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
                                  var dateTime = snapshot
                                      .data!.docs[index]['Date']
                                      .toDate();
                                  return SizedBox(
                                    height: 150,
                                    width: Get.width,
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
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Categories: ${snapshot.data?.docs[index]['Categories'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'InitialPrice: ${snapshot.data?.docs[index]['initialPrice'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Price: ${snapshot.data?.docs[index]['Price'].toString()}',
                                                    style: const TextStyle(
                                                        fontSize: 15),
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
                                                    "Date: ${DateFormat('yyyy-MM-dd KK:mm').format(dateTime)}",
                                                    style: const TextStyle(
                                                        fontSize: 15),
                                                  )
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
