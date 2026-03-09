import 'package:flutter/material.dart';

class NavItem {
  final IconData filledIcon;
  final IconData outlinedIcon;
  final String label;
  final Widget screen;

  const NavItem({
    required this.filledIcon,
    required this.outlinedIcon,
    required this.label,
    required this.screen,
  });
}