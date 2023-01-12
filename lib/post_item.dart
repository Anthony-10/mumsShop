import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constants.dart';
import 'controller.dart';

class EnterPost extends StatelessWidget {
  EnterPost({Key? key}) : super(key: key);

  final blogPostController = Get.put(BlogPostController());
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
                        maxHeight: 300,
                        minHeight: 200,
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

                  ///Prize
                  TextFormField(
                    key: const ValueKey("price"),
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      labelText: "Price",
                    ),
                    controller: blogPostController.itemPrice,
                  ),

                  SizedBox(
                    height: Get.height * 0.02,
                  ),

                  ///Category
                  TextFormField(
                    key: const ValueKey("initialPrice"),
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      labelText: "InitialPrice",
                    ),
                    controller: blogPostController.initialPrice,
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
                        ///Querying categories
                        await blogPostController.getCategories();

                        await blogPostController.imageBlog(
                          platform: "BlogImage",
                        );
                        print("Ty better next time");

                        ///Adding Category
                        if (blogPostController.itemsCatego
                            .contains(blogPostController.category)) {
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
