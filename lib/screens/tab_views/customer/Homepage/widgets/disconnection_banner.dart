import 'package:flutter/material.dart';

class MeterDisconnectedBanner extends StatelessWidget {
  const MeterDisconnectedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEBEB),
        border: Border.all(color: const Color(0xFFA32D2D), width: 0.8),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFA32D2D),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Meter blocked',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF501313),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your meter is currently disconnected. Clear your outstanding balance or contact support to reconnect.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF791F1F),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class MeterDisconnectedBanner extends StatelessWidget {
//   const MeterDisconnectedBanner({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF3CD),
//         borderRadius: BorderRadius.circular(10.0),
//         border: Border.all(color: const Color(0xFFFFB300), width: 1.2),
//         boxShadow: const [
//           BoxShadow(
//             color: Color.fromRGBO(0, 0, 0, 0.06),
//             offset: Offset(2, 2),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: const Row(
//         children: [
//           Icon(Icons.electric_meter_outlined,
//               color: Color(0xFFE65100), size: 28),
//           SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Meter Disconnected',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFFB71C1C),
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'Your meter has been blocked. Please contact support or make a payment to restore service.',
//                   style: TextStyle(
//                     fontSize: 11,
//                     color: Color(0xFF5D4037),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(width: 8),
//           Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB300), size: 22),
//         ],
//       ),
//     );
//   }
// }
