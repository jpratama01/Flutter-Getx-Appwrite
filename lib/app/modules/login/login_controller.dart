import 'package:app_write_demo/app/data/repository/auth_repository.dart';
import 'package:app_write_demo/app/modules/utils/custom_snack_bar.dart';
import 'package:app_write_demo/app/modules/utils/full_screen_dialog_loader.dart';
import 'package:app_write_demo/app/routes/app_pages.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  AuthRepository authRepository;
  LoginController(this.authRepository);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool isFormValid = false;
  final GetStorage _getStorage = GetStorage();

  @override
  void onClose() {
    super.onClose();
    emailEditingController.dispose();
    passwordEditingController.dispose();
  }

  void clearTextEditingControllers() {
    emailEditingController.clear();
    passwordEditingController.clear();
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

  void validateAndLogin({
    required String email,
    required String password,
  }) async {
    isFormValid = formKey.currentState!.validate();
    if (!isFormValid) {
      return;
    } else {
      formKey.currentState!.save();
      try {
        FullScreenDialogLoader.showDialog();
        await authRepository.login({
          "email": email,
          "password": password,
        }).then((value) {
          FullScreenDialogLoader.cancelDialog();
          clearTextEditingControllers();
          _getStorage.write("userId", value.userId);
          _getStorage.write("sessionId", value.$id);
          Get.offAllNamed(Routes.HOME);
          CustomSnackBar.showSuccessSnackBar(
            context: Get.context,
            title: "Success",
            message: "Login Success",
          );
        }).catchError((error) {
          FullScreenDialogLoader.cancelDialog();
          if (error is AppwriteException) {
            CustomSnackBar.showErrorSnackBar(
              context: Get.context,
              title: "Error",
              // message: error.response['message'],
              message: error.toString(),
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

  moveToSignUp() {
    Get.toNamed(Routes.SIGNUP);
  }
}
