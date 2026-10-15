import 'dart:math';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:otp_verify/app/routes/app_pages.dart';

class EmailController extends GetxController {
  final emailController = TextEditingController();
  final otpController = TextEditingController();

  final isLoading = false.obs;

  final String serviceId = 'service_x952nh3';
  final String templateId = 'template_kfdh7de';
  final String publicKey = 'Ac28SD3gcIKp3oa68';
  final String privateKey = '-SATal94pC4isO6C1peoT';

  Future<void> sendOtp() async {
    String email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    isLoading.value = true;

    try {
      String code = (100000 + Random().nextInt(900000)).toString();

      bool emailSent = await sendEmailViaEmailJS(email, code);

      if (!emailSent) {
        
        isLoading.value = false;
        return;
      }

      await FirebaseFirestore.instance.collection('otps').doc(email).set({
        'otp': code,
        'createdAt': DateTime.now(),
      });

      isLoading.value = false;
      Get.snackbar('Success', 'OTP sent to your email!');
      Get.toNamed(Routes.LOGIN);

    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Something went wrong: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<bool> sendEmailViaEmailJS(String email, String otpCode) async {
    const String url = "https://api.emailjs.com/api/v1.0/email/send";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'accessToken': privateKey,
          'template_params': {
            'to_email': email,
            'otp_code': otpCode,
          },
        }),
      ).timeout(const Duration(seconds: 15)); 

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        Get.snackbar('EmailJS Error', response.body,
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.orange,
            colorText: Colors.white);
        return false;
      }
    } catch (e) {
      Get.snackbar('Network Error', 'Could not connect to EmailJS: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  }

  Future<void> verifyOtp() async {
    String enteredCode = otpController.text.trim();
    String email = emailController.text.trim();

    if (enteredCode.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP');
      return;
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('otps')
          .doc(email)
          .get();

      if (!doc.exists) {
        Get.snackbar('Error', 'No OTP found. Please request a new one.');
        return;
      }

      String correctOtp = doc['otp'];

      if (correctOtp == enteredCode) {
        Get.snackbar('Success', 'Login Successful!');
        await FirebaseFirestore.instance.collection('otps').doc(email).delete();
        Get.offAllNamed(Routes.WELCOME);
      } else {
        Get.snackbar('Wrong Code', 'The OTP you entered is incorrect.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    super.onClose();
  }
}

