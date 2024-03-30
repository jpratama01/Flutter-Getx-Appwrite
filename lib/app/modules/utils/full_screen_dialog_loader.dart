import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenDialogLoader {
  static void showDialog() {
    Get.dialog(
      WillPopScope(
        onWillPop: () => Future.value(false),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.pink.withOpacity(0.2),
      useSafeArea: true,
    );
  }

  static void cancelDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
