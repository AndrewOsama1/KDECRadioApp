import 'dart:convert';

import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/data/firebase_controller.dart';
import 'package:church_app/app/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxBool loading = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);
  final Rx<String> username = ''.obs;
  final Rx<String> phoneNumber = ''.obs;
  final Rx<int> ageNumber = 0.obs;

  final BackendController _backendController = BackendController();
  final FirebaseController _firebaseController = Get.find<FirebaseController>();
  final RxBool isLoading = false.obs;

  Future<void> getUserProfile() async {
    isLoading(true);
    final UserModel? getUser = await _backendController
        .getUserInfo(_firebaseController.firebaseUser.value!.uid);
    if (getUser != null) {
      user(getUser);
      if (getUser.name.isNotEmpty) {
        username(getUser.name);
      }
      if (getUser.phone.isNotEmpty) {
        phoneNumber(getUser.phone);
      }
    }
    isLoading(false);
  }

  Future deleteProfile() async {
    loading(true);
    await Get.defaultDialog(
      content: Text('Are you sure you want to delete your account?'.tr),
      onConfirm: () =>
          Get.find<FirebaseController>().firebaseAuth.currentUser!.delete(),
      onCancel: Get.back,
    );
    loading(false);
  }

  Future updateUserName() async {
    if (username.value.isEmpty || username.value.length < 4) {
      return;
    }
    loading(true);
    await Get.find<FirebaseController>()
        .firebaseUser
        .value!
        .updateDisplayName(username.value);
    user(
      UserModel(
        email: Get.find<FirebaseController>().firebaseUser.value?.email ?? '',
        name: username.value,
        phone: user.value?.phone ?? '',
        age: 0,
        uid: Get.find<FirebaseController>().firebaseUser.value?.uid ?? '',
      ),
    );
    final String json = jsonEncode(user.toJson());
    BackendController()
        .updateUser(Get.find<FirebaseController>().userToken.value, json);
    await getUserProfile();
    loading(false);
  }

  Future updatePhoneNumber() async {
    if (phoneNumber.value.isEmpty || phoneNumber.value.length < 4) {
      return;
    }
    loading(true);
    user(
      UserModel(
        email: Get.find<FirebaseController>().firebaseUser.value?.email ?? '',
        name: user.value?.name ?? '',
        phone: phoneNumber.value,
        age: 0,
        uid: Get.find<FirebaseController>().firebaseUser.value?.uid ?? '',
      ),
    );
    final String json = jsonEncode(user.toJson());
    BackendController()
        .updateUser(Get.find<FirebaseController>().userToken.value, json);
    await getUserProfile();
    loading(false);
  }

  Future updateageNumber() async {
    if (ageNumber.value < 3) {
      return;
    }
    loading(true);
    user(
      UserModel(
        email: Get.find<FirebaseController>().firebaseUser.value?.email ?? '',
        name: user.value?.name ?? '',
        phone: user.value?.phone ?? '',
        age: ageNumber.value,
        uid: Get.find<FirebaseController>().firebaseUser.value?.uid ?? '',
      ),
    );
    final String json = jsonEncode(user.toJson());
    BackendController()
        .updateUser(Get.find<FirebaseController>().userToken.value, json);
    await getUserProfile();
    loading(false);
  }

  @override
  Future onInit() async {
    await getUserProfile();
    super.onInit();
  }
}
