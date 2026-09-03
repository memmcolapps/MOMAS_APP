import 'package:flutter/material.dart';

class IntroDot extends StatelessWidget {
  const IntroDot({
    super.key,
    required int currentIndex,
    required this.index,
  }) : _currentIndex = currentIndex;

  final int _currentIndex;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 12,
      width: _currentIndex == index ? 24 : 12,
      decoration: BoxDecoration(
        color: _currentIndex == index ? Colors.green : Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
