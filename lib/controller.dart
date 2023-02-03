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
  var id;
  int currentNumber = 0;

  final initialDate = DateTime.now().obs;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final TextEditingController itemPrice = TextEditingController();
  final TextEditingController initialPrice = TextEditingController();
  final TextEditingController category = TextEditingController();
  final TextEditingController subCategory = TextEditingController();
  final TextEditingController amount = TextEditingController();
  final TextEditingController searchItem = TextEditingController();
  final TextEditingController size = TextEditingController();

  void firstCategories() {
    if (itemsCatego.isNotEmpty) {
      item.value = itemsCatego[0];
    } else {
      return;
    }
  }

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

  Future<void> imageItem({
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
          postItem(url: element);
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

  Future<void> postItem({required var url}) async {
    try {
      await _fireStore.collection("ShopItems").doc(id).set({
        'Url': url,
        'Categories': category.text.trim().capitalizeFirst,
        'subCategory': subCategory.text.trim().capitalizeFirst,
        'Price': itemPrice.text.trim(),
        'Size': size.text.trim(),
        'initialPrice': initialPrice.text.trim(),
        'Amount': amount.text.trim(),
        'Date': initialDate.value,
        'Id': id.trim(),
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
        'Item': category.text.trim().capitalizeFirst,
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
  var itemSubCategory;
  var itemItemPrice;
  var itemInitialPrice;
  var itemUrl;
  var itemAmount;
  var itemDate;
  var itemSize;

  Future<void> soldItems() async {
    try {
      await _fireStore.collection("SoldItems").doc().set({
        'Url': itemUrl,
        'Categories': itemCategory,
        'subCategory': itemSubCategory,
        'Price': itemItemPrice,
        'Size': itemSize,
        'initialPrice': itemInitialPrice,
        'Amount': counter,
        'Date': DateTime.now(),
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

  var itemId = "";
  int exactAmount = 0;
  Future<void> updateItems() async {
    exactAmount = int.parse(itemAmount) - counter;
    try {
      await _fireStore.collection("ShopItems").doc(itemId).update({
        'Url': itemUrl,
        'Categories': itemCategory,
        'Price': itemItemPrice,
        'initialPrice': itemInitialPrice,
        'Amount': exactAmount,
        'Date': itemDate,
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
}
