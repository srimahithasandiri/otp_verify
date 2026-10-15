import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_verify/app/routes/app_pages.dart';

class PassLoginController extends GetxController {
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isloading = false.obs;

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Fill all the fields');
      return;
    }
    try {
      isloading.value = true;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar('sucess', 'Login successful');
      Get.offAllNamed(Routes.WELCOME);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Invalid credentials');
    } finally {
      isloading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
