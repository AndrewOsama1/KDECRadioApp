import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/widgets/custom_button.dart';
import 'package:church_app/app/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_svg_view.dart';
import '../controllers/authentication_controller.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool emailValid = true;
  String resetMessage = "";

  Future<void> _resetPassword() async {
    if (_emailController.text.trim().contains("@") &&
        _emailController.text.trim().contains(".")) {
      emailValid = true;
    } else {
      emailValid = false;
    }

    if (emailValid) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text.trim());
        setState(() {
          resetMessage =
              'A password reset email has been sent to ${_emailController.text.trim()}. Please check your inbox.';
        });
      } catch (e) {
        setState(() {
          resetMessage =
              ' Please make sure the email address is valid and registered.'.tr;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstant.black9000c,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Container(
            decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/good2.jpg'), // Your background image
                  fit: BoxFit.cover,
                ),
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 300,
                    width: 400,
                    decoration: const BoxDecoration(),
                    child: Container(
                      child: Center(
                        child: Image.asset('assets/images/kda.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(top: 10),
                    child: Text(
                      'Reset Your Password'.tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtUrbanistRomanBold32,
                    ),
                  ),
                  CustomTextFormField(
                    focusNode: FocusNode(),
                    controller: _emailController,
                    hintText: 'Enter Your Email'.tr,
                    margin: getMargin(top: 27),
                    padding: TextFormFieldPadding.PaddingT21,
                    fontStyle: TextFormFieldFontStyle.UrbanistRegular14Gray500,
                    textInputType: TextInputType.emailAddress,
                    prefix: Container(
                        margin:
                            getMargin(left: 20, top: 20, right: 12, bottom: 20),
                        child: CustomSvgView(
                          svgPath: ImageConstant.imgCheckmark,
                          color: Colors.blue,
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
                  CustomButton(
                    onTap: () async {
                      await _resetPassword();
                    },
                    margin: getMargin(top: 24),
                    padding: ButtonPadding.PaddingT18,
                    height: getVerticalSize(58),
                    text: 'Reset Your Password'.tr,
                  ),
                  if (resetMessage.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50.0),
                        child: Text(
                            ' Password reset has been sent to your Email'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtUrbanistSemiBold16.copyWith(
                                letterSpacing: getHorizontalSize(0.2)))),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
