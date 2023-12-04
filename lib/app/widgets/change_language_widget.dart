import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeLanguageWidget extends StatelessWidget {
  const ChangeLanguageWidget({
    Key? key,
    this.iconColor,
  }) : super(key: key);

  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.language,
        color: Colors.white,
      ),
      onSelected: (value) {
        Locale newLocale;

        if (value == 'English') {
          newLocale = const Locale('en');
        } else if (value == 'Français') {
          newLocale = const Locale('fr');
        } else if (value == 'العربية') {
          newLocale = const Locale('ar');
        } else {
          // Default to English if an unsupported language is selected
          newLocale = const Locale('en');
        }

        // Set the locale using Get for the entire app
        Get.updateLocale(newLocale);
      },
      itemBuilder: (BuildContext context) {
        return {'English', 'العربية', 'Français'}.map(
          (String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          },
        ).toList();
      },
    );
  }
}
