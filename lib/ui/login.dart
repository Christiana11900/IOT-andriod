import 'package:breathcare/ui/util/buildthem.dart';
import 'package:breathcare/ui/util/my_dialog.dart';
import 'package:breathcare/ui/util/route_constant.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';



class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);
  @override
  State<Loginscreen> createState() => _Loginscreen();
}

class _Loginscreen extends State<Loginscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<LoginController>(
        init: LoginController(),
    builder: (controller) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDFFFC),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 68,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Smart Villa".tr,
                          //textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF0A0A0A),
                            fontSize: 20,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Please provide the information below to login and"
                              .tr,
                          style: const TextStyle(
                            color: Color(0xff5E5D6F),
                            fontSize: 14,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w300,
                            //letterSpacing: 0.14,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "access your account. ".tr,
                              style: const TextStyle(
                                color: Color(0xff5E5D6F),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 43,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: 398,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'What’s your Username?'.tr,
                          //textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xff232949),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 378,
                          child: ButtonThem.buildTextFiled(
                              context, hintText: "Enter Username",
                              validator: usernameValidator,
                              controller: controller.username.value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: 398,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'What’s your password'.tr,
                          //textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xff232949),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ButtonThem.buildTextFiledWithSuffixIcon(
                      context,
                      hintText: 'password '.tr,
                      obscureText: obscure,
                      validator: password1Validator,
                      controller: controller.password.value,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            obscure = !obscure;
                          });
                        },
                        child: obscure
                            ? const Icon(
                          Icons
                              .visibility_off,
                          //change icon based on boolean value
                          color: Color.fromRGBO(196, 196, 196, 1),
                        )
                            : const Icon(
                          Icons
                              .visibility, //change icon based on boolean value
                          color: Color(0xff5E5D6F),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  ButtonThem.buildButton(
                    context,
                    title: controller.isLoading.value ? '' : 'Login'.tr,
                    color: controller.isLoading.value
                        ? Colors.blueAccent.withOpacity(0.7)
                        : Colors.blueAccent,
                    select: false,
                    circular: const Color(0xff367367),
                    btnRadius: 33,
                    textColor: const Color(0xFF2D2D2D),
                    onPress: controller.isLoading.value
                        ? () {}                            // disable button while loading
                        : () async {
                      if (_formKey.currentState!.validate()) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        HapticFeedback.lightImpact();  // vibration feedback on tap

                        // show loading
                        controller.isLoading.value = true;

                        try {
                          final connectivityResult =
                          await Connectivity().checkConnectivity();

                          if (connectivityResult == ConnectivityResult.none) {
                            HapticFeedback.heavyImpact();  // stronger vibrate on error
                            MyDialogs.error(
                              msg: 'You\'re not connected to a network',
                            );
                          } else {
                            // small delay so user sees loading spinner
                            await Future.delayed(const Duration(milliseconds: 800));

                            if (controller.username.value.text == "admin" &&
                                controller.password.value.text == "admin") {
                              HapticFeedback.mediumImpact();  // success feedback
                              Navigator.pushNamed(context, dashboard);
                            } else {
                              HapticFeedback.heavyImpact();
                              MyDialogs.error(
                                msg: 'Invalid username or password',
                              );
                            }
                          }
                        } catch (e) {
                          MyDialogs.error(msg: 'Something went wrong. Try again.');
                        } finally {
                          controller.isLoading.value = false;   // always stop loading
                        }
                      } else {
                        HapticFeedback.heavyImpact();  // vibrate on form validation fail
                      }
                    },
                  ),
                  if (controller.isLoading.value)
                    const Center(
                      child:  SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),

                  SizedBox(
                    height: 21,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
    );
  }

  String? Function(String?)? password1Validator = (String? value) {
    if (value!.isEmpty) {
      return 'Password cannot be empty';
    } else {
      return null;
    }
  };

  String? Function(String?)? usernameValidator = (String? value) {
    if (value!.isEmpty) {
      return 'Username cannot be empty';
    } else {
      return null;
    }
  };
}
