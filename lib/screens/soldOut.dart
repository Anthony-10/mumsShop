import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller.dart';

class SoldOut extends StatefulWidget {
  const SoldOut({Key? key}) : super(key: key);

  @override
  State<SoldOut> createState() => _SoldOutState();
}

class _SoldOutState extends State<SoldOut> {
  final blogPostController = Get.put(BlogPostController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    blogPostController.getShopItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
