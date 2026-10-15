import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:otp_verify/app/modules/email/controllers/email_controller.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginView'), centerTitle: true),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              Text(
                'Verify Your email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight(600),
                  color: Color(0xff231A13),
                ),
              ),
              Text(
                "Enter the 6-digit code sent to",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight(400),
                  color: Color(0xff2554336),
                ),
              ),

              SizedBox(height: 15),
              Container(
                height: 250,
                width: 350,
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Color(0xffFFFFFF)),
                  borderRadius: BorderRadius.circular(24),
                  color: Color(0xffFFFFFF),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: EmailController().otpController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          SizedBox(width: 40),
                          Text(
                            "Didn't receive the code?",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight(600),
                              color: Color(0xff554336),
                            ),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              "Resend in 00:57",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight(600),
                                color: Color(0xffB22B1D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      InkWell(
                        onTap: () {
                          final EmailController emailController =
                              EmailController();
                          emailController.verifyOtp();
                        },
                        child: Container(
                          height: 54,
                          width: 251,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(29),
                            gradient: LinearGradient(
                              colors: [Color(0xffEA5D09), Color(0xffFD9430)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight(600),
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
