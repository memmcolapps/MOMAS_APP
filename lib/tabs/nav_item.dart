import 'package:flutter/material.dart';

class NavItem {
  final String imageUrl;
  final String label;
  final Widget screen;

  const NavItem({
    required this.imageUrl,
    required this.label,
    required this.screen,
  });
}