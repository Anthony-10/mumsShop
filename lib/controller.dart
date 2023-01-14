import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class BlogPostController extends GetxController {
  final image = [].obs;
  final drawerImage = [].obs;
  List fileURLList = [];
  var fileURL = "";

  int counter = 1;
  var min = 2;

  final initialDate = DateTime.now().obs;

  var itemCategories = "thamos".obs;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final TextEditingController itemPrice = TextEditingController();
  final TextEditingController initialPrice = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController amount = TextEditingController();

  /*getImageGallery() async {
    image.clear();
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (pickedFile != null) {
      for (var selectedFile in pickedFile.files) {
        final File file = File(selectedFile.path!);
        image.add(file);
      }
    } else {
      Get.snackbar('Error', 'No image selected',
          snackPosition: SnackPosition.BOTTOM);
    }
  }*/

  getImageCamera() async {
    image.clear();
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image.add(File(pickedFile.path));
    } else {
      Get.snackbar('Error', 'No image selected',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> imageBlog({
    required String platform,
  }) async {
    fileURLList.clear();
    try {
      if (image.isNotEmpty) {
        for (var file in image) {
          final ref = firebase_storage.FirebaseStorage.instance
              .ref()
              .child("$platform/${DateTime.now().toString()}");
          final result = await ref.putFile(file);
          fileURL = await result.ref.getDownloadURL();

          fileURLList.add(fileURL);
        }
        image.clear();

        /// Updating the cloudFirebase
        /// postBlog
        for (var element in fileURLList) {
          postBlog(url: element);
        }

        itemPrice.clear();
        /*itemSellPrice.clear();*/
      } else {
        Get.snackbar(
          "Error",
          "Uploading Image",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Error Uploading Image",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> postBlog({required var url}) async {
    try {
      await _fireStore.collection("ShopItems").doc().set({
        'Url': url,
        'Categories': category.text,
        'Price': itemPrice.text,
        'initialPrice': initialPrice.text,
        'Amount': amount.text,
        'Date': initialDate.value,
      });
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Error Adding Post",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future pickDate(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
        context: Get.context!,
        initialDate: initialDate.value,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialEntryMode: DatePickerEntryMode.input,
        helpText: 'Select DOB',
        errorFormatText: 'Enter valid date',
        errorInvalidText: 'Enter valid date range',
        fieldLabelText: 'DOB');
    if (newDate != null && newDate != initialDate.value) {
      initialDate.value = newDate;
    }
  }

  List itemsCatego = [].obs;
  var items = "".obs;
  var item = ''.obs;
  Future getCategories() async {
    itemsCatego.clear();
    try {
      await FirebaseFirestore.instance
          .collection("Categories")
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach((doc) {
            items.value = doc['Item'];
            itemsCatego.add(items.value);
          });
        } else {
          print("No data");
          return;
        }
      });
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Error Adding User Info",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> categories() async {
    try {
      await _fireStore.collection("Categories").doc().set({
        'Item': category.text,
      });
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Error Adding User Info",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }

  var itemCategory;
  var itemItemPrice;
  var itemInitialPrice;
  var itemUrl;
  var itemAmount;
  var itemDate;

  Future<void> soldItems() async {
    try {
      await _fireStore.collection("SoldItems").doc().set({
        'Url': itemUrl,
        'Categories': itemCategory,
        'Price': itemItemPrice,
        'initialPrice': itemInitialPrice,
        'Amount': counter,
        'Date': DateTime.now(),
      });
      print('${initialDate.value},ggggggggggggggggggg');
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Error Adding Post",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }

  var itemsCategories;
  var itemsPrice;
  var itemsInitialPrice;
  var itemsAmount;
  var itemsUrl;
  var itemsDate;

  Future<void> getShopItems() async {
    FirebaseFirestore.instance
        .collection("ShopItems")
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          itemsCategories.value = doc['Categories'];
          itemsPrice.value = doc['Price'];
          itemsInitialPrice.value = doc['initialPrice'];
          itemsAmount.value = doc['Amount'];
          itemsUrl.value = doc['Url'];
          itemsDate.value = doc['Date'];
        });
      } else {
        print(
            'there is no data,llllllllllllllllllllllllllllllllllllllllllllllll');
      }
    });
  }
}
