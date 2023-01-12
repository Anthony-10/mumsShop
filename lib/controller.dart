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

  final initialDate = DateTime.now().obs;

  var itemCategories = "thamos".obs;

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final TextEditingController itemPrice = TextEditingController();
  final TextEditingController initialPrice = TextEditingController();
  final TextEditingController category = TextEditingController();

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

  int color = 0;
  Future<void> postBlog({required var url}) async {
    try {
      print('${initialDate.value},jjjjjjjjjjjjjjjjjjj');
      await _fireStore.collection("ShopItems").doc().set({
        'Url': url,
        'Categories': category.text,
        'Price': itemPrice.text,
        'initialPrice': initialPrice.text,
        'Date': initialDate.value,
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
    print("categories,vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv");
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

  /*Future<void> sendNotification(
      {required String title,
      required String token,
      required String body}) async {
    print('sendNotification>>>>>>>>>>>>>>>>>>>>>>>>>');
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'message': title,
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=BBk0HHIFASeUu4WRT50EAHWohuQVw49Trt_0SqAb8zvagowgB66rpa7hfDOp_x6l90jxrM7pdQSw9x_Gy0PyxVI'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{'title': title, 'body': body},
                'priority': 'high',
                'data': data,
                'to': token
              }));
      print(
          '${response.statusCode}>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
      if (response.statusCode == 200) {
        print('your notification is send');
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }*/

  /*var token;
  final listImage = [].obs;
  Future<void> getUserToken() async {
    print('getUserToken,>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    final uuid = FirebaseAuth.instance.currentUser?.uid;
    try {
      FirebaseFirestore.instance
          .collection("NotificationToken")
          */ /*.where('id', isEqualTo: uuid)*/ /*
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.forEach((doc) {
            token = doc['token'];
            sendNotification(
                title: selectedItem.value.toString(),
                body: '${selectedItem.value.toString()} updated',
                token: token);
            */ /*listImage.add(token);*/ /*

            print('$listImage,44444444444444444444444444444444444444');
          });
        } else {
          print('<<<<<<<<<<No data>>>>>>>>>>>');
        }
      });
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Error Adding User Token",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      rethrow;
    }
  }*/
}
