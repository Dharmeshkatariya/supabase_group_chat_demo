import 'package:get/get.dart';

import '../services/network_services.dart';
import 'export.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              noInternetAnimation,
              width: 100.w,
            ),
            Text(
              "No Internet Connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15.sp,
                color: Colors.black,
              ),
            ),
            20.verticalSpace,
            Text(
              textAlign: TextAlign.center,
              "Please check your internet connection and try again.",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.sp,
                color: Colors.grey,
              ),
            ),
            20.verticalSpace,
            CommonButton(
              text: 'Retry',
              height: 45,
              width: 120,
              ontap: () {
                bool isConnected =
                    Get.find<GetXNetworkManager>().isConnected.value;
                if (isConnected) {
                  Get.back();
                } else {
                  Utility.noInternetDialog();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
