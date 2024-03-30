import 'package:app_write_demo/app/data/models/employee_model.dart';
import 'package:app_write_demo/app/data/repository/auth_repository.dart';
import 'package:app_write_demo/app/modules/utils/custom_snack_bar.dart';
import 'package:app_write_demo/app/modules/utils/full_screen_dialog_loader.dart';
import 'package:app_write_demo/app/routes/app_pages.dart';
import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController with StateMixin<List<Employee>> {
  HomeController(this.authRepository);
  AuthRepository authRepository;

  final GetStorage _getStorage = GetStorage();
  late List<Employee> employeeList = [];

  @override
  onReady() {
    getEmployee();
  }

  logout() async {
    try {
      FullScreenDialogLoader.showDialog();
      await authRepository.logout(_getStorage.read('sessionId')).then((value) {
        FullScreenDialogLoader.cancelDialog();
        _getStorage.erase();
        Get.offAllNamed(Routes.LOGIN);
        CustomSnackBar.showSuccessSnackBar(
          context: Get.context,
          title: "Success",
          message: "Logout Success",
        );
      }).catchError((error) {
        FullScreenDialogLoader.cancelDialog();
        (error is AppwriteException)
            ? CustomSnackBar.showErrorSnackBar(
                context: Get.context,
                title: "Error",
                // message: error.response['message'],
                message: error.toString(),
              )
            : CustomSnackBar.showErrorSnackBar(
                context: Get.context,
                title: "Error",
                message: "Something went wrong",
              );
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

  moveToCreateEmployee() {
    Get.toNamed(Routes.CREATE_EMPLOYEE);
  }

  moveToEditEmployee(Employee employee) {
    Get.toNamed(Routes.CREATE_EMPLOYEE, arguments: employee);
  }

  deleteEmployee(Employee employee) async {
    print('ID : ${employee.documentId}');
    try {
      FullScreenDialogLoader.showDialog();
      await authRepository.deleteEmployee({
        "documentId": employee.documentId,
      }).then((value) async {
        await authRepository.deleteEmployeeImage(employee.image);
        FullScreenDialogLoader.cancelDialog();
        CustomSnackBar.showSuccessSnackBar(
          context: Get.context,
          title: "Success",
          message: "Employee Deleted",
        );
        Get.offAllNamed(Routes.HOME);
      }).catchError((error) async {
        print(error);
        FullScreenDialogLoader.cancelDialog();
        (error is AppwriteException)
            ? CustomSnackBar.showErrorSnackBar(
                context: Get.context,
                title: "Error",
                message: error.response['message'])
            : CustomSnackBar.showErrorSnackBar(
                context: Get.context,
                title: "Error",
                message: "Something went wrong");
      });
    } catch (e) {
      print(e);
      FullScreenDialogLoader.cancelDialog();
      CustomSnackBar.showErrorSnackBar(
          context: Get.context,
          title: "Error",
          message: "Something went wrong");
    }
  }

  getEmployee() async {
    try {
      change(null, status: RxStatus.loading());
      await authRepository.getEmployees().then((value) {
        Map<String, dynamic> data = value.toMap();
        List d = data['documents'].toList();
        employeeList = d.map((e) => Employee.fromMap(e['data'])).toList();
        change(employeeList, status: RxStatus.success());
      }).catchError((error) {
        (error is AppwriteException)
            ? change(null, status: RxStatus.error(error.response['message']))
            : change(null, status: RxStatus.error("Something went wrong"));
      });
    } catch (e) {
      change(null, status: RxStatus.error("Something went wrong"));
    }
  }
}
