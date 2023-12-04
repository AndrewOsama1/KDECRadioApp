import 'dart:convert';
import 'dart:developer';

import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/models/user_info.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:church_app/app/modules/authentication/controllers/authentication_controller.dart';

import '../core/utils/http.dart';

class FirebaseController extends GetxController {
  static FirebaseController instance = Get.find();
  late Rx<User?> firebaseUser;
  final Rx<String> userToken = ''.obs;
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

  @override
  void onInit() {
    firebaseUser = Rx<User?>(firebaseAuth.currentUser);
    firebaseUser.bindStream(firebaseAuth.userChanges());
    ever(firebaseUser, _setInitialScreen);
    super.onInit();
  }

//get user info
  Future<void> _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAllNamed(Routes.AUTHENTICATION);
    } else {
      Get.offAllNamed(Routes.HOME);
      final User? firebaseUser =
          Get.find<FirebaseController>().firebaseUser.value;
      if (firebaseUser != null) {
        final UserModel? userInfo =
            await Get.find<BackendController>().getUserInfo(firebaseUser.uid);

        if (userInfo == null) {
          final UserModel user = UserModel(
            email: firebaseUser.email ?? '',
            name: firebaseUser.displayName ?? '',
            phone: firebaseUser.phoneNumber ?? '',
            age: 0,
            uid: firebaseUser.uid,
          );

          final Map<String, dynamic> userJson = user.toJson();
          final String jsonData = jsonEncode(userJson);

          await Get.find<BackendController>()
              .createUser(userToken.value, jsonData);
        }
      }
    }
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => firebaseAuth.idTokenChanges();
// signs out from firebase account
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

// sign in as a guest and send the info to the server api
  Future<void> signinAnony() async {
    final UserCredential createdUser = await firebaseAuth.signInAnonymously();
    if (createdUser.user != null && createdUser.user?.uid != null) {
      final UserModel user = UserModel(
        email: createdUser.user?.email ?? '',
        name: createdUser.user?.displayName ?? '',
        phone: '',
        age: 0,
        uid: createdUser.user!.uid,
      );

      final Map<String, dynamic> userJson = user.toJson();
      final String jsonData = jsonEncode(userJson);

      await Get.find<BackendController>().createUser(userToken.value, jsonData);
      // Set the display name to the user-provided value
    }
  }

//sign up and send it to firebase server and api server
  Future<void> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final UserCredential createdUser =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (createdUser.user != null && createdUser.user?.uid != null) {
        final UserModel user = UserModel(
          email: createdUser.user?.email ?? '',
          name: createdUser.user?.displayName ?? '',
          phone: '',
          age: 0,
          uid: createdUser.user!.uid,
        );

        final Map<String, dynamic> userJson = user.toJson();
        final String jsonData = jsonEncode(userJson);

        await Get.find<BackendController>()
            .createUser(userToken.value, jsonData);
        // Set the display name to the user-provided value
        await createdUser.user!.updateDisplayName(displayName);
      }
    } catch (e) {
      log(e.toString());
    }
  }

// login to firebase
  Future<void> login({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
    }
  }
}

//handle the new token from the http
Future<void> handleTokenRequest() async {
  final user = FirebaseAuth.instance.currentUser;
  final _dio = await http();
  if (user == null) {
    // Handle the case when the user is not authenticated.
    // You might want to show an error message or take appropriate action.
    return;
  }

  final url = 'https://kdec-church-testing-app.onrender.com';
  final data = {
    'uid': user.uid,
  };

  try {
    final response = await _dio.post(
      url + "/api/en/auth/token",
      data: data,
    );

    if (response.statusCode == 201) {
      final token = response.data['results']['token'];
      print('Response Data: ${response.data}');

      // Store the response data in shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);

      print('Token saved in shared preferences.');
    } else {
      print('Request failed with status: ${response.data}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
