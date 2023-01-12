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
        body: Padding(
          padding: EdgeInsets.only(
            top: Get.height * .02,
            left: Get.width * .03,
            right: Get.width * .03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: Get.height * .06,
                    left: Get.width * .07,
                    bottom: Get.height * .02),
                child: Container(
                    child: const Text(
                  'Bought',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                )),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("ShopItems")
                        .where("Categories",
                            isEqualTo: blogPostController.itemCategories.value)
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
                                  return FittedBox(
                                    child: Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: Get.height * .15,
                                              width: Get.width * .25,
                                              child: Card(
                                                child: CachedNetworkImage(
                                                  /*cacheManager: buyController
                                                      .customCacheManager,*/
                                                  imageUrl: snapshot.data
                                                      ?.docs[index]['image'],
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
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
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
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
                                              width: Get.width * .2,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Name: ${snapshot.data?.docs[index]['name'].toString()}'),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Price: ${snapshot.data?.docs[index]['price'].toString()}'),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Size: ${snapshot.data?.docs[index]['size'].toString()}'),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Amount: ${snapshot.data?.docs[index]['amount'].toString()}'),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Date: ${snapshot.data?.docs[index]['date'].toString()}'),
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
            ],
          ),
        ),
      ),
    );
  }
}
