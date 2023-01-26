import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/alertDialogs.dart';
import '../controller.dart';

class SreachItem extends StatelessWidget {
  SreachItem({Key? key}) : super(key: key);

  final blogPostController = Get.put(BlogPostController());
  var itemSearch = ''.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30, left: 100, bottom: 20),
              child: Text(
                'Searchtems',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            TextFormField(
              key: const ValueKey("searchItem"),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                icon: IconButton(
                  onPressed: () {
                    itemSearch.value =
                        blogPostController.searchItem.text.trim();
                    print("${itemSearch.value},oooooooooooooooooooooooooooooo");
                  },
                  icon: const Icon(
                    Icons.search,
                    size: 30,
                  ),
                ),
                labelText: "Search",
              ),
              controller: blogPostController.searchItem,
            ),
            SizedBox(
              height: 20,
            ),
            Obx(
              () => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("ShopItems")
                          .where("Categories",
                              isEqualTo: itemSearch.value.capitalizeFirst)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
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
                                      height: 170,
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
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    blogPostController.itemUrl =
                                                        snapshot.data
                                                                ?.docs[index]
                                                            ['Url'];
                                                    blogPostController
                                                            .itemSubCategory =
                                                        snapshot.data
                                                                ?.docs[index]
                                                            ['subCategory'];
                                                    blogPostController
                                                            .itemCategory =
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                                ['Categories']
                                                            .toString();

                                                    blogPostController
                                                            .itemSize =
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                                ['Size']
                                                            .toString();

                                                    blogPostController
                                                            .itemInitialPrice =
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                                ['initialPrice']
                                                            .toString();
                                                    blogPostController
                                                            .itemItemPrice =
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                                ['Price']
                                                            .toString();
                                                    blogPostController
                                                            .itemAmount =
                                                        snapshot
                                                            .data
                                                            ?.docs[index]
                                                                ['Amount']
                                                            .toString();
                                                    blogPostController
                                                        .itemDate = snapshot
                                                            .data!.docs[index]
                                                        ['Date'];
                                                    blogPostController.itemId =
                                                        snapshot.data
                                                            ?.docs[index]['Id'];
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            const AlertDialogs());
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                      Text(
                                                        'Amount: ${snapshot.data?.docs[index]['Amount'].toString()}',
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Date: ${DateFormat('yyyy-MM-dd KK:mm').format(dateTime)}",
                                                        style: const TextStyle(
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
