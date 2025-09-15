import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MyDialogs {
  static bool flag = false;

  static success({required String msg}) {
    Get.snackbar('Success', msg,
        colorText: Colors.white,
        backgroundColor: Colors.green.withOpacity(.9),
        duration: const Duration(seconds: 4));
  }

  static dynamic error({required dynamic msg}) {
    //flag = true;
    Get.snackbar('Error', msg,
        colorText: Colors.white,
        backgroundColor: Colors.redAccent.withOpacity(.9),
        duration: const Duration(seconds: 4));
  }

  static info({required String msg}) {
    Get.snackbar('Info', msg, colorText: Colors.white,
        backgroundColor: const Color(0xFF9FAEA2).withOpacity(0.9),
        duration: const Duration(seconds: 4));
  }

  static showProgress() {
    // flag = true;
    Get.dialog(const Center(
        child: CircularProgressIndicator(strokeWidth: 2)));
    //     .whenComplete(() {
    //       print('Completed here');
    //       flag = true;
    // });
  }

  static dismiss() {
    flag = false;
    Get.back();
  }

}