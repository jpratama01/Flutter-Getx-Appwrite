import 'package:app_write_demo/app/data/provider/appwrite_provider.dart';
import 'package:app_write_demo/app/data/repository/auth_repository.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
        () => LoginController(AuthRepository(AppWriteProvider())));
  }
}
