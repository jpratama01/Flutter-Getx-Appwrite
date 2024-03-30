import 'package:app_write_demo/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  final count = 0.obs;
  final GetStorage _getStorage = GetStorage();

  @override
  void onReady() {
    super.onReady();
    // Future.delayed(
    //   const Duration(seconds: 3),
    //   () => Get.offAllNamed(Routes.LOGIN),
    // );

    (_getStorage.read("userId") != null)
        ? Get.offAllNamed(Routes.HOME)
        : Get.offAllNamed(Routes.LOGIN);
  }

  void increment() => count.value++;
}
