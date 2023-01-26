import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../components/ImageDialog.dart';
import '../controller.dart';

class Sold extends StatelessWidget {
  Sold({Key? key}) : super(key: key);

  final blogPostController = Get.put(BlogPostController());

  final nowsDate = DateTime.now();
  var dateNow;
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
                'SoldItems',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    /*dateNow =
                        print('$dateNow,llllllllllll');*/
                  },
                  child: Container(
                    height: 40,
                    width: 100,
                    child: Center(
                        child: Text(DateFormat('yyyy-MM-dd').format(nowsDate))),
                    color: Colors.amber,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 40,
                    width: 100,
                    child: Center(
                        child: Text(DateFormat('yyyy-MM').format(nowsDate))),
                    color: Colors.amber,
                  ),
                ),
                /*TextButton(
                    onPressed: () {},
                    child:
                        Text("${DateFormat('yyyy-MM-dd').format(nowsDate)}")),
                TextButton(
                    onPressed: () {},
                    child: Text("${DateFormat('yyyy-MM').format(nowsDate)}"))*/
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("SoldItems")
                        .where('Date', isLessThanOrEqualTo: DateTime.now())
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
                                                child: GestureDetector(
                                                  onTap: () {
                                                    blogPostController.itemUrl =
                                                        snapshot.data
                                                                ?.docs[index]
                                                            ['Url'];
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            ImageDialog());
                                                  },
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
                                                    'SubCategory: ${snapshot.data?.docs[index]['subCategory'].toString()}',
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
                                                    'Size: ${snapshot.data?.docs[index]['Size'].toString()}',
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
