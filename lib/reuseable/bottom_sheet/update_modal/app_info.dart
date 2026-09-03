import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/modal_content_header.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';

class AppInfo extends StatelessWidget {
  final String appSize;
  final String version;

  const AppInfo({
    required this.appSize,
    required this.version,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          // App Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MoColors.mainColor,
                  MoColors.mainColorII,
                ],
              ),
            ),
            child: Center(
              child: Image.asset(MoImage.logo, width: 36, height: 36),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MomasPay plus',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F1F1F),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.get_app,
                      size: 16,
                      color: Color(0xFF5F6368),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      version,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5F6368),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "($appSize)",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5F6368),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
