import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_app_demo/utils/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import '../utils/export.dart';

class AuthServices extends GetxService {
  static final authClient = SupabaseService.client.auth;
  static final client = SupabaseService.client;

  bool get isAuthenticated {
    final session = authClient.currentSession;
    return session != null;
  }

  String? get loggedUid {
    final session = authClient.currentSession;
    return session?.user.id;
  }

  static Future<Either<String, AuthResponse>> register({
    required String email,
    required String password,
    required String name,
    required String profileImageUrl,
  }) async {
    try {
      final existingUserResponse = await SupabaseService.client
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle()
          .execute();

      if (existingUserResponse.data != null) {
        return const Left('Email already in use');
      }

      final response =
          await authClient.signUp(email: email, password: password, data: {
        "name": name,
      });
      final userId = response.user?.id;
      if (userId != null) {
        var data = {"name": name, "image": profileImageUrl};
        await SupabaseService.client.from('users').upsert({
          'id': userId,
          'email': email,
          'name': name,
          'image': profileImageUrl,
          "metadata": data,
        }).execute();
      }

      return Right(response);
    } on AuthException catch (err) {
      print(err);
      return Left(err.message);
    }
  }

  static Future<Either<String, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await SupabaseService.client.auth
          .signInWithPassword(email: email, password: password);
      return Right(response);
    } on AuthException catch (err) {
      return Left(err.message);
    }
  }

  static Future<Either<String, void>> sendOtp({
    required String phone,
  }) async {
    final formattedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    try {
      await authClient.signInWithOtp(
          shouldCreateUser: true, phone: formattedPhone);
      return const Right(null);
    } on AuthException catch (err) {
      return Left(err.message);
    }
  }

  static Future<Either<String, void>> verfiy({
    required String phone,
    required String otpToken,
  }) async {
    try {
      final formattedPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
      await authClient.verifyOTP(
        token: otpToken,
        type: OtpType.phoneChange,
        phone: formattedPhone,
      );
      return const Right(null);
    } on AuthException catch (err) {
      return Left(err.message);
    }
  }

  static Future<Either<String, AuthResponse>> googleSignInLogin() async {
    try {
      const webClientId =
          '993994292711-3jvk930m2hrht4a8bk39ghb4lq0a6n1u.apps.googleusercontent.com';
      const iosClientId =
          '993994292711-3jvk930m2hrht4a8bk39ghb4lq0a6n1u.apps.googleusercontent.com';
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return const Left('Google Sign-In cancelled by user.');
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        return const Left('No Access Token found.');
      }
      if (idToken == null) {
        return const Left('No ID Token found.');
      }
      AuthResponse res = await authClient.signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      return Right(res);
    } catch (e) {
      print('Google Sign-In failed: $e');
      return Left('Google Sign-In failed: ${e.toString()}');
    }
  }

  Future<Either<String, void>> signOut() async {
    try {
      await authClient.signOut(scope: SignOutScope.global);
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      return const Right(null);
    } catch (e) {
      print('Sign-Out failed: $e');
      return Left('Sign-Out failed: ${e.toString()}');
    }
  }

  static final _fbAuth = FacebookAuth.instance;

  static _fbLogout() async {
    await _fbAuth.logOut();
  }

  Future<void> initiateFacebookLogin() async {
    final result = await FlutterWebAuth.authenticate(
        url:
            "https://mkwiszognicuzhfajjkq.supabase.co/auth/v1/authorize?provider=facebook",
        callbackUrlScheme: "https");
    print('Auth result: $result');
  }

  static Future<Either<String, Map<String, dynamic>>> fbLogin() async {
    try {
      final LoginResult fbAc = await _fbAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (fbAc.status == LoginStatus.success) {
        final fbData = await _fbAuth.getUserData(fields: 'email,name,picture');
        final response = await authClient.signInWithOAuth(
          Provider.facebook,
        );
        return Right({
          'userCredential': response,
          'userData': fbData,
        });
      } else if (fbAc.status == LoginStatus.cancelled) {
        _fbLogout();
        return const Left('Facebook login cancelled by user.');
      } else if (fbAc.status == LoginStatus.failed) {
        _fbLogout();
        return Left('Facebook login failed: ${fbAc.message}');
      } else {
        return const Left('Unexpected Facebook login status.');
      }
    } catch (e) {
      print('Facebook login failed: $e');
      return Left('Facebook login failed: ${e.toString()}');
    }
  }

  static Future<Either<String, bool>> githubLogin() async {
    try {
      var res = await authClient.signInWithOAuth(
        Provider.github,
      );

      return Right(res);
    } on AuthException catch (err) {
      return Left(err.message);
    }
  }
}
