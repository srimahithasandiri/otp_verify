import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDF8F3),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 100),

                 

                  const Text(
                    'Verify Your Number',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff231A13),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Enter the 6-digit code sent to',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff255433),
                    ),
                  ),

                  const SizedBox(height: 5),


                  Text(
                    controller.phoneNumber.isEmpty
                        ? '+91 XXXXX XXXXX'
                        : controller.phoneNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff8F4E00),
                    ),
                  ),

                  const SizedBox(height: 20),

                 

                  Container(
                    width: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                       

                        TextField(
                          controller: controller.otpController,

                          keyboardType: TextInputType.number,

                          textInputAction:
                              TextInputAction.done,

                          textAlign: TextAlign.center,

                          maxLength: 6,

                         
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                          ],

                                                   obscureText: true,

                        
                          obscuringCharacter: '•',

                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff231A13),
                            letterSpacing: 10,
                          ),

                          decoration: InputDecoration(
                            counterText: '',

                            hintText: '------',

                            hintStyle: const TextStyle(
                              color: Color(0xffD8CFC7),
                              letterSpacing: 8,
                            ),

                            filled: true,

                            fillColor:
                                const Color(0xffFFF8F2),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(
                                color: Color(0xffE5D8CC),
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(
                                color: Color(0xffEA5D09),
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                       

                        Obx(
                          () {
                          
                            if (controller
                                .isResending.value) {
                              return const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color:
                                      Color(0xffEA5D09),
                                ),
                              );
                            }

                            return Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive the code?",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight:
                                        FontWeight.w600,
                                    color:
                                        Color(0xff554336),
                                  ),
                                ),

                                const SizedBox(width: 5),

                               
                                if (!controller
                                    .canResend.value)
                                  Text(
                                    'Resend in '
                                    '${controller.formattedTime}',
                                    style:
                                        const TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.w600,
                                      color:
                                          Color(0xffB22B1D),
                                    ),
                                  )

                               
                                else
                                  GestureDetector(
                                    onTap:
                                        controller.resendOtp,
                                    child: const Text(
                                      'Resend OTP',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                            FontWeight.w600,
                                        color:
                                            Color(0xffEA5D09),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                      

                        Obx(
                          () => InkWell(
                            onTap: controller
                                    .isLoading.value
                                ? null
                                : controller.verifyOtp,

                            borderRadius:
                                BorderRadius.circular(29),

                            child: Container(
                              height: 54,
                              width: 251,

                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(29),

                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Color(0xffEA5D09),
                                    Color(0xffFD9430),
                                  ],
                                ),
                              ),

                              child: Center(
                                child: controller
                                        .isLoading.value

                                    
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child:
                                            CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )

                                   
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


