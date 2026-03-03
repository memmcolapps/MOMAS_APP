import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class NavDestination extends StatelessWidget {
  final bool isSelected;
  final String imageUrl;

  const NavDestination({
    required this.isSelected,
    required this.imageUrl,
    super.key
  });

  @override
  Widget build(BuildContext context) {
      return NavigationDestination(
        label: '',
        icon: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageIcon(
                AssetImage(imageUrl),
                size: 20,
                color: isSelected ? MoColors.mainColor : Colors.grey,
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 5,
                width: 60,
                decoration: BoxDecoration(
                  color: isSelected ? MoColors.mainColor : Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
