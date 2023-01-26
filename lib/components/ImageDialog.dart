import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';

class ImageDialog extends StatelessWidget {
  ImageDialog({Key? key}) : super(key: key);
  final blogPostController = Get.put(BlogPostController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Sold"),
        content: SizedBox(
          width: double.infinity,
          height: 300,
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
        ));
  }
}
