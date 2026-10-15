import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final phoneController = TextEditingController();
  final isLoading = false.obs;

  Future<void> sendOtp() async {
    String phone = phoneController.text.trim();

    phone = phone.replaceAll(' ', '');

    if (phone.startsWith('+91')) {
      phone = phone.substring(3);
    }

    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    if (phone.length != 10 ||
        !RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      Get.snackbar(
        'Invalid Number',
        'Enter a valid 10-digit mobile number.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final fullPhoneNumber = '+91$phone';

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,

        verificationCompleted:
            (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);

            Get.offAllNamed(Routes.WELCOME);
          } finally {
            isLoading.value = false;
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;

          Get.snackbar(
            'Verification Failed',
            e.message ?? 'Failed to send OTP.',
            snackPosition: SnackPosition.BOTTOM,
          );
        },

        codeSent: (
          String verificationId,
          int? resendToken,
        ) {
          isLoading.value = false;

          Get.toNamed(
            Routes.OTP,
            arguments: {
              'verificationId': verificationId,
              'phoneNumber': fullPhoneNumber,
            },
          );
        },

        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Something went wrong.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
