import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CustomProgressBar extends StatelessWidget {
  final Rx<Duration> progress;
  final Rx<Duration> buffered;
  final Rx<Duration> total;
  final Function(Duration) onSeek;
  final Color durationTextColor;

  CustomProgressBar({
    super.key,
    required this.progress,
    required this.buffered,
    required this.total,
    required this.onSeek,
    required this.durationTextColor,
  });

  @override
  Widget build(BuildContext context) {
    // Extract double values from Rx<Duration> using .value
    final double progressValue = progress.value.inMilliseconds.toDouble();
    final double bufferedValue = buffered.value.inMilliseconds.toDouble();
    final double totalValue = total.value.inMilliseconds.toDouble();

    return SliderTheme(
      data: SliderThemeData(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayColor: Colors.red,
        showValueIndicator: ShowValueIndicator.always,
        valueIndicatorTextStyle: TextStyle(
          color: durationTextColor,
        ),
      ),
      child: Slider(
        value: progressValue,
        min: 0,
        max: totalValue,
        onChanged: (value) {},
        onChangeEnd: (value) {
          final Duration seekDuration = Duration(milliseconds: value.toInt());
          onSeek(seekDuration);
        },
        activeColor: Colors.blue,
        inactiveColor: Colors.grey,
        semanticFormatterCallback: (double value) {
          final duration = Duration(milliseconds: value.toInt());
          return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
        },
      ),
    );
  }
}
