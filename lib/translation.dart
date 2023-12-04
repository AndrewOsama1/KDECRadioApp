import 'package:church_app/lang/ar.dart';
import 'package:church_app/lang/en.dart';
import 'package:church_app/lang/fr.dart';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ar': ar,
        'en': en,
        'fr': fr,
      };
}
