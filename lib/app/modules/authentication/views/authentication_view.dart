import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/firebase_controller.dart';
import 'package:church_app/app/modules/authentication/views/reset_password.dart';
import 'package:church_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:church_app/app/widgets/custom_button.dart';
import 'package:church_app/app/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_password_view.dart';
import '../../../widgets/custom_svg_view.dart';
import '../../send_prayer/controllers/send_prayer_controller.dart';
import '../controllers/authentication_controller.dart';

@override
void dependencies() {
  Get.put<SendPrayerController>(SendPrayerController());
  Get.put<ProfileController>(ProfileController());

  Get.put<AuthenticationController>(AuthenticationController());
}

class AuthenticationView extends GetView<AuthenticationController> {
  AuthenticationView({Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/good2.jpg'),
              fit: BoxFit.cover, // Your background image
            ),
          ),
          child: Obx(
            () => Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Adjust as needed
                  children: [
                    Container(
                      height: 250,
                      width: 600,
                      child: Container(
                        child: Padding(
                          padding: getPadding(top: 10),
                          child: Center(
                            child: Image.asset('assets/images/kdc.png'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(top: 1),
                      child: Text(
                        controller.isLogin.value
                            ? 'Login to Your Account'.tr
                            : 'Signup'.tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtUrbanistRomanBold32,
                      ),
                    ),
                    if (!controller.isLogin.value)
                      CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: controller.displayName,
                        hintText: 'Name'.tr,
                        margin: getMargin(top: 27),
                        padding: TextFormFieldPadding.PaddingT21,
                        fontStyle:
                            TextFormFieldFontStyle.UrbanistRegular14Gray500,
                        textInputType: TextInputType.name,
                        prefix: Container(
                            margin: getMargin(
                                left: 20, top: 16, right: 12, bottom: 20),
                            child: const Icon(
                              Icons.account_box,
                              size: 30,
                              color: Colors.blue,
                            )),
                        prefixConstraints:
                            BoxConstraints(maxHeight: getVerticalSize(60)),
                        validator: (value) {
                          if (controller.isLogin.value) {
                            return null;
                          }
                          if (value != null && value.length > 3) {
                            return null;
                          }
                          return 'Please enter a valid name'.tr;
                        },
                      ),
                    CustomTextFormField(
                      focusNode: FocusNode(),
                      controller: controller.emailController,
                      hintText: 'Email'.tr,
                      margin: getMargin(top: 27),
                      padding: TextFormFieldPadding.PaddingT21,
                      fontStyle:
                          TextFormFieldFontStyle.UrbanistRegular14Gray500,
                      textInputType: TextInputType.emailAddress,
                      prefix: Container(
                          margin: getMargin(
                              left: 20, top: 10, right: 12, bottom: 10),
                          child: CustomSvgView(
                            svgPath: ImageConstant.imgCheckmark,
                          )),
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(60)),
                      validator: (value) {
                        if (value != null && GetUtils.isEmail(value)) {
                          return null;
                        }
                        return 'Please enter a valid email'.tr;
                      },
                    ),
                    Obx(
                      () => CustomTextFormField(
                        focusNode: FocusNode(),
                        controller: controller.passwordController,
                        hintText: 'Password'.tr,
                        margin: getMargin(top: 24),
                        padding: TextFormFieldPadding.PaddingT21_1,
                        fontStyle:
                            TextFormFieldFontStyle.UrbanistRegular14Gray500,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        prefix: Container(
                            margin: getMargin(
                                left: 20, top: 10, right: 12, bottom: 10),
                            child:
                                CustomSvgView(svgPath: ImageConstant.imgLock)),
                        prefixConstraints:
                            BoxConstraints(maxHeight: getVerticalSize(60)),
                        suffix: InkWell(
                            onTap: () {
                              controller.isShowPassword.value =
                                  !controller.isShowPassword.value;
                            },
                            child: Container(
                                margin: getMargin(
                                    left: 30, top: 10, right: 20, bottom: 10),
                                child: CustomPasswordView(
                                    svgPath: controller.isShowPassword.value
                                        ? ImageConstant.imgDashboard
                                        : ImageConstant.imgDashboard))),
                        suffixConstraints:
                            BoxConstraints(maxHeight: getVerticalSize(60)),
                        isObscureText: controller.isShowPassword.value,
                        validator: (value) {
                          if (value != null && value.length > 6) {
                            return null;
                          }
                          return 'Please enter a valid password'.tr;
                        },
                        onFieldSubmitted: (value) {
                          // Handle onFieldSubmitted here
                          print('Field submitted with value: $value');
                        },
                      ),
                    ),
                    CustomButton(
                      onTap: () => controller.authenticated(formKey),
                      margin: getMargin(top: 14),
                      padding: ButtonPadding.PaddingT18,
                      height: getVerticalSize(58),
                      text: controller.isLogin.value ? 'Login'.tr : 'Signup'.tr,
                    ),
                    InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResetScreen())),
                        child: Padding(
                            padding: getPadding(top: 27),
                            child: Text('Forget Password'.tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtUrbanistSemiBold16.copyWith(
                                    letterSpacing: getHorizontalSize(0.2))))),
                    GestureDetector(
                        onTap: () async {
                          await Get.find<FirebaseController>().signinAnony();
                        },
                        child: Padding(
                            padding: getPadding(top: 27),
                            child: Text('Continue As Guest'.tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtUrbanistSemiBold16.copyWith(
                                    letterSpacing: getHorizontalSize(0.2))))),
                    Padding(
                        padding: getPadding(top: 14),
                        child: Divider(
                            height: getVerticalSize(1),
                            thickness: getVerticalSize(1),
                            color: ColorConstant.blueGray100)),
                    Padding(
                        padding: getPadding(top: 10, bottom: 5),
                        child: GestureDetector(
                            onTap: () {
                              controller.isLogin.toggle();
                            },
                            child: Padding(
                                padding: getPadding(left: 8, top: 1),
                                child: Text(
                                    !controller.isLogin.value
                                        ? 'Already Got an account,Login'.tr
                                        : "Don't have an account,Signup".tr,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle
                                        .txtUrbanistSemiBold14RedA70002
                                        .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2)))))),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
