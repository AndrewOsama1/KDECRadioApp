import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:get/get.dart';

class DiscoverController extends GetxController {
  RxBool loadingData = true.obs;
  RxList<Map<Object, String>> categories = RxList<Map<Object, String>>([]);

  @override
  Future<void> onInit() async {
    categories(await Get.find<BackendController>().getCategories());
    loadingData(false);
    super.onInit();
  }
}
