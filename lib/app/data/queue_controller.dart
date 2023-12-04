import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';

class QueueController extends GetxController {
  final RxList<MediaItem> _queue = RxList<MediaItem>([]);

  void add(MediaItem item) => _queue.add(item);

  MediaItem getItem(int index) => _queue[index];

  bool isLast(int index) => index == _queue.length - 1;

  bool isFirst(int index) => index == 0;

  void clearQueue() => _queue.clear();

  void isEmpty() => _queue.isEmpty;

  void isNotEmpty() => _queue.isNotEmpty;
  void addAll(List<MediaItem> m) => _queue.addAll(m);
  List<MediaItem> get getQueue => _queue;
}
