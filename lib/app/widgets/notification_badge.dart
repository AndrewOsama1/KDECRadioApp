import 'package:flutter/material.dart';

class IconWithRedBadge extends StatelessWidget {
  final IconData iconData;

  IconWithRedBadge({required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(iconData),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: 12, // Adjust the width and height as needed
            height: 12,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
