import 'dart:io';

import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/firebase_controller.dart';
import 'package:church_app/app/widgets/custom_text_form_field.dart';
import 'package:church_app/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../widgets/custom_button.dart';
import '../controllers/profile_controller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class MyProfileView extends GetView<ProfileController> {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = Get.find<FirebaseController>().firebaseUser.value;
    final isAnonymous = firebaseUser?.isAnonymous == true;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/good2.jpg'),
            fit: BoxFit.cover,
          ),
          border: Border.all(),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Obx(
          () => controller.loading.value
              ? Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    size: 40,
                    color: Colors.white,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(
                    children: [
                      Padding(
                        padding: getPadding(top: 5, bottom: 50),
                        child: Center(
                          child: Text(
                            'Profile'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtUrbanistRomanBoldm,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          'Username'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtUrbanistRomanBold32,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        onChanged: (value) => controller.username(value),
                        helperText: controller.username.value,
                        hintText:
                            isAnonymous ? 'Name'.tr : controller.username.value,
                        suffix: SizedBox(
                          width: 0.25 * Get.width,
                          child: Row(
                            children: [
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  await controller.updateUserName();
                                  await controller.getUserProfile();
                                },
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: controller.getUserProfile,
                                icon: const Icon(Icons.cancel_outlined,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 0.01 * Get.height,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          'Phone'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtUrbanistRomanBold32,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        onChanged: (value) => controller.phoneNumber(value),
                        hintText: isAnonymous
                            ? 'Phone'.tr
                            : controller.phoneNumber.value,
                        suffix: SizedBox(
                          width: 0.25 * Get.width,
                          child: Row(
                            children: [
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  await controller.updatePhoneNumber();
                                  await controller.getUserProfile();
                                },
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: controller.getUserProfile,
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 0.01 * Get.height,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          'Age'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtUrbanistRomanBold32,
                        ),
                      ),
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        onChanged: (value) {
                          int? parsedValue = int.tryParse(value);
                          if (parsedValue != null) {
                            controller.ageNumber(parsedValue);
                          }
                        },
                        hintText: isAnonymous
                            ? 'Age'.tr
                            : controller.ageNumber.value.toString(),
                        suffix: SizedBox(
                          width: 0.25 * Get.width,
                          child: Row(
                            children: [
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () async {
                                  await controller.updateageNumber();
                                  await controller.getUserProfile();
                                },
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: controller.getUserProfile,
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: getPadding(top: 24),
                          child: Divider(
                              height: getVerticalSize(1),
                              thickness: getVerticalSize(1),
                              color: ColorConstant.blueGray100)),
                      Padding(
                          padding: getPadding(top: 33, bottom: 5),
                          child: CustomButton(
                            onTap: () async {
                              Get.find<FirebaseController>()
                                  .firebaseAuth
                                  .signOut();
                            },
                            height: getVerticalSize(58),
                            text:
                                isAnonymous ? 'Create Account'.tr : 'Logout'.tr,
                            margin: getMargin(left: 24, right: 24, bottom: 48),
                            variant: ButtonVariant.FillGray80002,
                            padding: ButtonPadding.PaddingAll19,
                          )),
                      Visibility(
                        visible: !isAnonymous,
                        child: CustomButton(
                          onTap: controller.deleteProfile,
                          height: getVerticalSize(58),
                          text: 'Delete Account'.tr,
                          margin: getMargin(left: 24, right: 24, bottom: 48),
                          variant: ButtonVariant.FillGray80002,
                          padding: ButtonPadding.PaddingAll19,
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
