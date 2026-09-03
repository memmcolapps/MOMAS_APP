
import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class ContactPickerButton extends StatelessWidget {
  const ContactPickerButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MoColors.mainColorLight,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: MoColors.mainColor.withOpacity(0.1),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: MoColors.mainColorMid, width: 1),
          ),
          child: const Icon(
            Icons.contacts_outlined,
            size: 22,
            color: MoColors.mainColor,
          ),
        ),
      ),
    );
  }
}