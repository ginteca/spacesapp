import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final ImageProvider<Object> icon;
  final int index;
  final int selectedIndex;
  final GestureTapCallback onTap;
  final double iconSize;

  ToggleButton({
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(children: [
          if (isSelected)
            Image(
              image: icon,
              width: 100,
              height: 100,
            ),
          if (!isSelected)
            Image(
              image: icon,
              width: 72,
              height: 72,
            )
        ]),
      ),
    );
  }
}
