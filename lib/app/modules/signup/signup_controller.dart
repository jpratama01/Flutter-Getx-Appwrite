import 'package:app_write_demo/app/data/repository/auth_repository.dart';
import 'package:app_write_demo/app/modules/utils/custom_snack_bar.dart';
import 'package:app_write_demo/app/modules/utils/full_screen_dialog_loader.dart';
import 'package:app_write_demo/app/routes/app_pages.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  AuthRepository authRepository;
  SignupController(this.authRepository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();

  bool isFormValid = false;

  @override
  void onClose() {
    super.onClose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
    nameEditingController.dispose();
  }

  void clearTextEditingControllers() {
    emailEditingController.clear();
    passwordEditingController.clear();
    nameEditingController.clear();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide valid Email";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "Provide valid password";
    }
    return null;
  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Provide valid name";
    }
    return null;
  }

  void validateAndSignUp({
    required String? email,
    required String? password,
    required String? name,
  }) async {
    isFormValid = formKey.currentState!.validate();
    if (!isFormValid) {
      return;
    } else {
      formKey.currentState!.save();
      try {
        FullScreenDialogLoader.showDialog();
        await authRepository.signup({
          "userId": ID.unique(),
          "name": name,
          "email": email,
          "password": password,
        }).then((value) {
          FullScreenDialogLoader.cancelDialog();
          CustomSnackBar.showSuccessSnackBar(
              context: Get.context,
              title: "Success",
              message: "User account created");
          clearTextEditingControllers();
          Get.offAllNamed(Routes.LOGIN);
        }).catchError((error) {
          FullScreenDialogLoader.cancelDialog();
          if (error is AppwriteException) {
            CustomSnackBar.showErrorSnackBar(
              context: Get.context,
              title: "Error",
              message: error.response['message'],
            );
          } else {
            CustomSnackBar.showErrorSnackBar(
              context: Get.context,
              title: "Error",
              message: "Something went wrong",
            );
          }
        });
      } catch (e) {
        FullScreenDialogLoader.cancelDialog();
        CustomSnackBar.showErrorSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong",
        );
      }
    }
  }
}
