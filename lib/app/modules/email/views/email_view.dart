import 'package:flutter/material.dart';

import 'package:get/get.dart';


import '../controllers/email_controller.dart';

class EmailView extends GetView<EmailController> {
  const EmailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 400,
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: Colors.red.shade100,
            ),
            child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign up or Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight(700),
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: "email",
                      hintText: "mahitha@gmail.com",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight(400),
                        color: Color(0xff554336),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                 
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      controller.sendOtp();
                      //Get.toNamed(Routes.LOGIN);
                    },
                    child: Obx(() {
                      return Container(
                        height: 52,
                        width: 245,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(29),
                          gradient: LinearGradient(
                            colors: [Colors.red.shade200, Colors.red.shade300],
                          ),
                        ),
                        child: Center(
                          child: controller.isLoading.value == true?
                                   CircularProgressIndicator()
                          :Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight(600),
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                        ),
                      );
                    }),
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
