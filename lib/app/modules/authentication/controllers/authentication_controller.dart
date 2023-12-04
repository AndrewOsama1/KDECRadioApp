import 'package:church_app/app/data/firebase_controller.dart';
import 'package:church_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationController extends GetxController {
  final RxBool isLogin = true.obs;
  final RxBool visiblePass = false.obs;
  Rx<bool> isShowPassword = true.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController displayName = TextEditingController();
  final dio = Dio();

  String? token;
  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  void handleDioError(DioError error, ErrorInterceptorHandler handler) {
    if (error.response != null) {
      final response = error.response!;
      final statusCode = response.statusCode;
      final responseBody = response.data;
      print('Error Status Code: $statusCode');
      print('Error Response Body: $responseBody');
    } else {
      print('Network Error: ${error.message}');
    }
    handler.next(error);
  }

  void configureDioWithToken(String token) {
    dio.interceptors.add(InterceptorsWrapper(onError: handleDioError));

    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers['Cookie'] = 'S_UT=$token';
      return handler.next(options);
    }));
  }

  // dio.interceptors.add(InterceptorsWrapper(onError: handleDioError));
  // dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
  // options.headers['Cookie'] = 'S_UT=$token';
  // return handler.next(options);
  // }));

  Future<void> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user object from the userCredential
      User? user = userCredential.user;
      if (user != null) {
        // Set the display name for the user
        await user.updateDisplayName(displayName);
      }

      // Handle successful sign up
      // You can add additional logic or navigation here if needed.
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth errors as you have already done
      // ...
    } catch (e) {
      // Handle other errors
      print('Error: $e');
    }
  }

  void authenticated(GlobalKey<FormState> formKey) async {
    print(displayName);
    if (formKey.currentState!.validate()) {
      if (isLogin.value) {
        // Login flow

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          await handleTokenRequest();

          // Handle successful login
        } catch (e) {
          if (e is FirebaseAuthException) {
            if (e.code == 'user-not-found') {
              // Handle user not found (email not registered) error
              Get.snackbar(
                'Login Error'.tr,
                'The Email or Password is incorrect.'.tr,
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            } else if (e.code == 'wrong-password') {
              // Handle wrong password error
              Get.snackbar(
                'Login Error'.tr,
                'The Email or Password is incorrect.'.tr,
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            } else {
              // Handle other login errors
              Get.snackbar(
                'Login Error',
                'An error occurred during login. Please try again.',
                backgroundColor: Colors.white,
                colorText: Colors.black,
              );
            }
          }
        }
      } else {
        // Sign up flow
        try {
          await Get.find<FirebaseController>().signup(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              displayName: displayName.text.trim());
          // Handle successful sign up
        } catch (e) {
          if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
            print(
                'Caught error: ${e.message}'); // Print the error message for additional debugging
            // Show a Snackbar to the user
            Get.snackbar(
              'Sign Up Error'.tr,
              'The email is already in use. Please use a different email.'.tr,
              backgroundColor: Colors.white,
              colorText: Colors.black,
            );
          } else {
            // For other errors, provide a general error message
            print(
                'Unhandled error: ${e.toString()}'); // Print other errors for debugging
            Get.snackbar(
              'Sign Up Error'.tr,
              'An error occurred during sign up. Please try again.',
              backgroundColor: Colors.white,
              colorText: Colors.black,
            );
          }
        }
      }
    }
  }
}
