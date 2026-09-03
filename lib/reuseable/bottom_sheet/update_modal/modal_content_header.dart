import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/images.dart';

class ModalContentHeader extends StatelessWidget {
  final bool mandatory;
  final bool isIOS;
  final Function(BuildContext context) onClose;

  const ModalContentHeader({
    required this.mandatory,
    required this.isIOS,
    required this.onClose,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(isIOS ? MoImage.appStore : MoImage.playStore,
                  width: 24, height: 24),
              const SizedBox(width: 12),
              Text(
                isIOS ? 'App store' : 'Google Play',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF5F6368),
                ),
              ),
            ],
          ),
          if (!mandatory)
            IconButton(
              icon: const Icon(Icons.close, color: Color(0xFF5F6368)),
              onPressed: () => onClose(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
