import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../controller.dart';

class EnterPost extends StatefulWidget {
  EnterPost({Key? key}) : super(key: key);

  @override
  State<EnterPost> createState() => _EnterPostState();
}

class _EnterPostState extends State<EnterPost> {
  final blogPostController = Get.put(BlogPostController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blogPostController.getCategories().then((value) =>
        print("${blogPostController.itemsCatego},kkkkkkkkkkkkklllllllllll"));

    /*FirebaseMessaging.onMessage.listen((event) {
      print('FCM message received');
    });*/
  }

  var selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            blogPostController.getImageCamera();
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      "Post Blog",
                      style: TextStyle(
                          color: kDarkBlackColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  ///Photo
                  Container(
                    color: Colors.white,
                    constraints: const BoxConstraints(
                        maxHeight: 400,
                        minHeight: 300,
                        maxWidth: 400,
                        minWidth: 300),
                    child: Obx(
                      () => blogPostController.image.isNotEmpty
                          ? Image.file(
                              blogPostController.image.first,
                              fit: BoxFit.fill,
                            )
                          : const Icon(Icons.add),
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),

                  ///Category

                  /* SizedBox(
                      height: 100,
                      width: 300,
                      child: DropdownButton(
                          value: selectedCategory,
                          items: blogPostController.itemsCatego
                              .map((item) => DropdownMenuItem(
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    value: item,
                                  ))
                              .toList(),
                          onChanged: (item) =>
                              setState(() => selectedCategory = item))),*/

                  TextFormField(
                    key: const ValueKey("category"),
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      labelText: "Category",
                    ),
                    controller: blogPostController.category,
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  ///subCategory
                  TextFormField(
                    key: const ValueKey("subCategory"),
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      labelText: "subCategory",
                    ),
                    controller: blogPostController.subCategory,
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  ///Size
                  TextFormField(
                    key: const ValueKey("size"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Size",
                    ),
                    controller: blogPostController.size,
                  ),

                  ///Prize
                  TextFormField(
                    key: const ValueKey("price"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price",
                    ),
                    controller: blogPostController.itemPrice,
                  ),

                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  ///initialPrice
                  TextFormField(
                    key: const ValueKey("initialPrice"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "InitialPrice",
                    ),
                    controller: blogPostController.initialPrice,
                  ),

                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  ///Amount
                  TextFormField(
                    key: const ValueKey("Amount"),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                    ),
                    controller: blogPostController.amount,
                  ),

                  const SizedBox(
                    height: 50.0,
                  ),

                  ///Date
                  Obx(
                    () => Text(
                      '${blogPostController.initialDate.value.year}/${blogPostController.initialDate.value.month}/${blogPostController.initialDate.value.day}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        blogPostController.pickDate(context);
                        print(
                            '${DateTime.parse(blogPostController.initialDate.value.toString())},nnnnnnnnnnnnnnnn');
                      },
                      child: const Text('Press')),
                  const SizedBox(
                    height: 25.0,
                  ),

                  const SizedBox(
                    height: 40.0,
                  ),

                  ///Blog

                  ElevatedButton(
                      onPressed: () async {
                        const uuid = Uuid();
                        blogPostController.id = uuid.v1();
                        print(
                            "Ty better next timelllllllllllllllllllllllllllllllllllll");

                        ///Querying categories
                        await blogPostController.getCategories();
                        print(
                            "${blogPostController.itemsCatego},aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                        print(
                            "Ty better next timemmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
                        await blogPostController.imageBlog(
                          platform: "BlogImage",
                        );
                        print("Ty better next timeoooooooooooooooooooooo");

                        ///Adding Category
                        if (blogPostController.itemsCatego
                            .contains(blogPostController.category.text)) {
                          print("Try better next time");
                        } else {
                          blogPostController.categories();
                        }
                      },
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 1.5,
                              vertical: kDefaultPadding)),
                      child: const Text("Send"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
