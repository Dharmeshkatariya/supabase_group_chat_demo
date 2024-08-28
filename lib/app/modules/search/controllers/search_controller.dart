import 'dart:async';
import 'package:get/get.dart';
import '../../../../models/user_model.dart';
import '../../../../services/user_services.dart';

class SearchViewController extends GetxController {
  var loading = false.obs;
  var notFound = false.obs;
  RxList<UserModel?> users = RxList<UserModel?>();
  Timer? _debounce;

  Future<void> searchUser(String name) async {
    loading.value = true;
    notFound.value = false;
    await UserServices.searchUser(name, _debounce).then((res) {
      res.fold((l) {
        loading.value = false;
      }, (data) {
        loading.value = false;
        if (data.isNotEmpty) {
          users.value = data;
        } else {
          notFound.value = true;
        }
      });
    });
  }
}
