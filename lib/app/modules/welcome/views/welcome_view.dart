import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: const Center(
        child: Text(
          'Welcome ',
          style: TextStyle(
            fontSize: 20
          ),
        ),
      ),
    );
  }
}

