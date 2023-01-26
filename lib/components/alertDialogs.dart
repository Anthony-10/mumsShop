import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller.dart';

class AlertDialogs extends StatefulWidget {
  const AlertDialogs({Key? key}) : super(key: key);

  @override
  State<AlertDialogs> createState() => _AlertDialogsState();
}

class _AlertDialogsState extends State<AlertDialogs> {
  final blogPostController = Get.put(BlogPostController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Sold"),
      content: SizedBox(
        height: 180,
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
                        imageUrl: blogPostController.itemUrl,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          color: Colors.black12,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.black12,
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                      ),
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 20.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories: ${blogPostController.itemCategory}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'InitialPrice: ${blogPostController.itemInitialPrice}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Price: ${blogPostController.itemItemPrice}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Amount: ${blogPostController.itemAmount}',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Date: ${DateFormat('yyyy-MM-dd KK:mm').format(blogPostController.itemDate)}",
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    height: Get.height * .04,
                    width: Get.width * .1,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(70)),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          blogPostController.counter++;
                        });
                      },
                      child: const Icon(Icons.add),
                    )),
                SizedBox(
                  width: Get.width * .03,
                ),
                Text('${blogPostController.counter}'),
                SizedBox(
                  width: Get.width * .03,
                ),
                Container(
                    height: Get.height * .04,
                    width: Get.width * .1,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(70)),
                    child: GestureDetector(
                        onTap: () {
                          if (blogPostController.counter >=
                              blogPostController.min) {
                            setState(() {
                              blogPostController.counter--;
                            });
                          } else {
                            return;
                          }
                        },
                        child: const Icon(Icons.remove))),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  blogPostController.soldItems();
                  blogPostController.updateItems();
                  Navigator.pop(context);
                },
                child: const Text("Sold")),
          ],
        )
      ],
    );
  }
}
