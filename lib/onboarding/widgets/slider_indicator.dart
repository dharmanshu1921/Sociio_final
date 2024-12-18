import 'package:flutter/material.dart';

class SliderIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Color dotColor;
  final Color dotActiveColor;
  final double dotSize;
  final double activeDotSize;

  SliderIndicator({
    required this.currentIndex,
    required this.itemCount,
    this.dotColor = Colors.white,
    this.dotActiveColor = const Color(0xFFFF3131),
    this.dotSize = 8.0,
    this.activeDotSize = 15.0, // Set the size for the active dot
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: index == currentIndex ? activeDotSize : dotSize, // Use activeDotSize for the active dot
          height: dotSize,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: index==currentIndex?BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: dotActiveColor,
          ):BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        );
      }),
    );
  }
}
