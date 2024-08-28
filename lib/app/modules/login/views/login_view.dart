import 'package:flutter/gestures.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/utils/export.dart';
import '../../../../utils/button_styles.dart';
import '../../../../widgets/auth_input.dart';
import '../controllers/login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController mobile = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  final LoginController controller = Get.put(LoginController());
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  void login() {
    if (_form.currentState!.validate()) {
      if (!controller.loginLoading.value) {
        controller.login(emailController.text, passwordController.text);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 60,
                  height: 60,
                ),
                10.verticalSpace,
                const Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text("Welcome back,"),
                    ],
                  ),
                ),
                10.verticalSpace,
                AuthInput(
                  hintText: "Enter your email",
                  label: "Email",
                  controller: emailController,
                  callback: ValidationBuilder().email().build(),
                ),
                20.verticalSpace,
                AuthInput(
                  hintText: "Enter your password",
                  label: "Password",
                  controller: passwordController,
                  isPasswordField: true,
                ),

                20.verticalSpace,
                Obx(
                  () => ElevatedButton(
                    style: authButtonStyle(
                      controller.loginLoading.value
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white,
                      Colors.black,
                    ),
                    onPressed: login,
                    child: Text(controller.loginLoading.value
                        ? "Processing..."
                        : "Submit"),
                  ),
                ),
                20.verticalSpace,
                Obx(() {
                  return CommonButton(
                    ontap: () {
                      controller.googleLogin();
                    },
                    text: controller.googleLoginLoading.value
                        ? "Loading"
                        : 'Google',
                  );
                }),

                20.verticalSpace,
                Obx(() {
                  return CommonButton(
                    ontap: () {
                      controller.facebookLogin();
                    },
                    text: controller.fbLoading.value ? "Loading" : 'Facebook',
                  );
                }),

                20.verticalSpace,
                Obx(() {
                  return CommonButton(
                    ontap: () {
                      controller.githubLoginuset();
                    },
                    text: controller.githubLoading.value ? "Loading" : 'Github',
                  );
                }),

                // 20.verticalSpace,
                // Obx(() {
                //   return CommonButton(
                //     ontap: () {
                //       controller.githubLoginuset();
                //     },
                //     text: controller.githubLoading.value ?
                //     "Loading" :
                //     'Figma',
                //   );
                // }),
                // 20.verticalSpace,
                // AuthInput(
                //   hintText: "Mobile Number",
                //   label: "Mobile",
                //   controller: mobile,
                // ),
                // 20.verticalSpace,
                //
                // Obx(() {
                //   return CommonButton(
                //     ontap: () {
                //       controller.sendOtp(mobile.text.trim());
                //     },
                //     text: controller.otpLoading.value ?
                //     "Loading" :
                //     'Send otp',
                //   );
                // }),
                const SizedBox(height: 20),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: " Sign up",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.toNamed(Routes.REGISTER)),
                ], text: "Don't have an account ?"))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
