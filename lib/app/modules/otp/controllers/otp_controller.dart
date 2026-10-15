import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class OtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final otpController = TextEditingController();

  final isLoading = false.obs;
  final isResending = false.obs;

  final secondsRemaining = 60.obs;
  final canResend = false.obs;

  Timer? _timer;

  String verificationId = '';
  String phoneNumber = '';

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments != null) {
      verificationId =
          arguments['verificationId']?.toString() ?? '';

      phoneNumber =
          arguments['phoneNumber']?.toString() ?? '';
    }

    startTimer();
  }

  void startTimer() {
    _timer?.cancel();

    secondsRemaining.value = 60;
    canResend.value = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (secondsRemaining.value > 0) {
          secondsRemaining.value--;
        } else {
          canResend.value = true;
          timer.cancel();
        }
      },
    );
  }

  String get formattedTime {
    final minutes = secondsRemaining.value ~/ 60;
    final seconds = secondsRemaining.value % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> verifyOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Enter the 6-digit OTP.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (verificationId.isEmpty) {
      Get.snackbar(
        'Error',
        'Verification session expired. Resend OTP.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isLoading.value) return;

    try {
      isLoading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final idToken = await userCredential.user?.getIdToken();

      if (idToken == null || idToken.isEmpty) {
        Get.snackbar(
          'Error',
          'Unable to retrieve the Firebase ID token.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Get.snackbar(
        'Firebase ID Token',
        idToken,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(minutes: 1),
        mainButton: TextButton(
          onPressed: () async {
            try {
              await Clipboard.setData(ClipboardData(text: idToken));
              Get.snackbar(
                'Copied',
                'Firebase ID token copied to clipboard.',
                snackPosition: SnackPosition.BOTTOM,
              );
            } catch (e) {
              Get.snackbar(
                'Copy failed',
                'Unable to copy the Firebase ID token: $e',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('COPY'),
        ),
      );

      Get.offAllNamed(Routes.WELCOME);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-verification-code':
          message = 'Incorrect OTP.';
          break;

        case 'session-expired':
          message = 'OTP expired. Please resend.';
          break;

        default:
          message = e.message ?? 'OTP verification failed.';
      }

      Get.snackbar(
        'Verification Failed',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (!canResend.value || isResending.value) {
      return;
    }

    if (phoneNumber.isEmpty) {
      Get.snackbar(
        'Error',
        'Phone number is missing.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isResending.value = true;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        verificationCompleted:
            (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            Get.offAllNamed(Routes.WELCOME);
          } finally {
            isResending.value = false;
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          isResending.value = false;

          Get.snackbar(
            'Error',
            e.message ?? 'Failed to resend OTP.',
            snackPosition: SnackPosition.BOTTOM,
          );
        },

        codeSent: (
          String newVerificationId,
          int? resendToken,
        ) {
          verificationId = newVerificationId;

          otpController.clear();

          isResending.value = false;

          startTimer();

          Get.snackbar(
            'OTP Sent',
            'New OTP sent successfully.',
            snackPosition: SnackPosition.BOTTOM,
          );
        },

        codeAutoRetrievalTimeout: (String newVerificationId) {
          verificationId = newVerificationId;
          isResending.value = false;
        },
      );
    } catch (e) {
      isResending.value = false;

      Get.snackbar(
        'Error',
        'Failed to resend OTP.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    super.onClose();
  }
}
