import 'package:get/get.dart';
import 'package:supabase_app_demo/services/auth_services.dart';
import '../../../../utils/export.dart';
import '../../../../utils/storage/storage.dart';
import '../../../../utils/storage/storage_key.dart';

class LoginController extends GetxController {
  final registerLoading = false.obs;
  final loginLoading = false.obs;
  final otpLoading = false.obs;
  final googleLoginLoading = false.obs;
  final fbLoading = false.obs;
  final githubLoading = false.obs;

  Future<void> register(String name, String email, String password) async {
    registerLoading.value = true;
    await AuthServices.register(
            email: email, password: password, name: name, profileImageUrl: ""!)
        .then((res) {
      res.fold((l) {
        registerLoading.value = false;
        showSnackBar("Error", "Something went wrong");
      }, (r) {
        registerLoading.value = false;
        if (r.user != null) {
          Storage.session.write(StorageKey.session, r.session!.toJson());
          Get.offAllNamed(Routes.DashboardView);
        } else {
          showSnackBar("Error", "Something went wrong");
        }
      });
    });
  }

  Future googleLogin() async {
    googleLoginLoading.value = true;
    await AuthServices.googleSignInLogin().then((res) {
      res.fold((l) {
        googleLoginLoading.value = false;
      }, (response) {
        googleLoginLoading.value = false;
        if (response.user != null) {
          Storage.session.write(StorageKey.session, response.session!.toJson());
          Get.offAllNamed(Routes.DashboardView);
        }
      });
    });
  }

  Future facebookLogin() async {
    fbLoading.value = true;
    await AuthServices.fbLogin().then((res) {
      res.fold((l) {
        fbLoading.value = false;
      }, (response) {
        fbLoading.value = false;
      });
    });
  }

  Future githubLoginuset() async {
    githubLoading.value = true;
    await AuthServices.githubLogin().then((res) {
      res.fold((l) {
        githubLoading.value = false;
      }, (response) {
        githubLoading.value = false;
      });
    });
  }

  Future<void> login(String email, String password) async {
    loginLoading.value = true;
    AuthServices.login(email: email, password: password).then((res) {
      res.fold((l) {
        loginLoading.value = false;
        loginLoading.value = false;
        showSnackBar("Error", l);
      }, (response) {
        loginLoading.value = false;
        if (response.user != null) {
          Storage.session.write(StorageKey.session, response.session!.toJson());
          Get.offAllNamed(Routes.DashboardView);
        }
      });
    });
  }

  Future<void> sendOtp(String phone) async {
    otpLoading.value = true;
    await AuthServices.sendOtp(phone: phone).whenComplete(() {
      otpLoading.value = false;
    });
  }
}
