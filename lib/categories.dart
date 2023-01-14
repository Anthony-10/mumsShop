import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final blogPostController = Get.put(BlogPostController());
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _fireStore.collection("Categories").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.size,
                    itemBuilder: (BuildContext context, int index) {
                      final categories = snapshot.data?.docs[index]['Item'];
                      return Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                //TODO
                                blogPostController.item.value = categories;
                              });
                            },
                            child: Container(
                              height: Get.height * .06,
                              width: Get.width * .3,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: Get.width * .01,
                                    right: Get.width * .01),
                                child: Center(
                                    child: Text(categories.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17))),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }
            }
            return const Text("Loading....");
          } else {
            return Container(
                height: 80,
                width: Get.width,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        const SizedBox(
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
        });
  }
}
