import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LiveAnimation extends StatefulWidget {
  const LiveAnimation({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LiveAnimationState createState() => _LiveAnimationState();
}

class _LiveAnimationState extends State<LiveAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Icon(
        CupertinoIcons.circle_fill,
        color: Colors.red,
        size: 13,
      ),
    );
  }
}
