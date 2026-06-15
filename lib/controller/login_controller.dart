import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TextEditingController> username = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;
}