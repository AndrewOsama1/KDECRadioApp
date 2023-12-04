import 'package:get/get.dart';

import '../controllers/audio_player_controller.dart';

class AudioPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AudioPlayerController>(AudioPlayerController());
  }
}
