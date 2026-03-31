import 'package:flutter/material.dart';

class MeterDisconnectedBanner extends StatelessWidget {
  const MeterDisconnectedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEBEB),
        border: Border.all(color: const Color(0xFFA32D2D), width: 0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Row(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFA32D2D),
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Meter Inactive - Contact support for help.',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF501313),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
