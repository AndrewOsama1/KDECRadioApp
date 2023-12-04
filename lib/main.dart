import 'dart:developer';
import 'package:church_app/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:church_app/app/modules/splash/controllers/splash_controller.dart';
import 'package:church_app/app_constants.dart';
import 'package:church_app/firebase_options.dart';
import 'package:church_app/translation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'app/firebaseapi.dart';
import 'app/modules/send_prayer/bindings/send_prayer_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SendPrayerBinding().dependencies();
  Get.put<AuthenticationController>(AuthenticationController());

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await configureAmplify();
  await FirebaseApi().initNotifications();
  // Save the token to shared preferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token != null) {
    // Configure Dio with the saved token
    AuthenticationController().configureDioWithToken(token);
  }
  runApp(
    GetMaterialApp(
      title: 'KDEC Radio',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
        Locale('fr'),
      ],
      translations: AppTranslation(),
      fallbackLocale: const Locale('ar'),
      locale: Get.deviceLocale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        primaryColor: AppConstants.primaryColor,
        fontFamily: 'ArabicSukar',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          secondary: Colors.blue,
        ),
      ),
    ),
  );
  FlutterNativeSplash.remove();
}
