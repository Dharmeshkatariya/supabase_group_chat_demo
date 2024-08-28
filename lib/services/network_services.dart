import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class GetXNetworkManager extends GetxService {
  RxBool isConnected = true.obs;

  Stream get connectivityListener => Connectivity().onConnectivityChanged;

  @override
  void onInit() {
    super.onInit();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        isConnected.value = false;
      } else {
        isConnected.value = true;
      }
    });
  }
}
