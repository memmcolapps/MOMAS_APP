// import 'package:flutter/material.dart';
// import 'package:momaspayplus/screens/auth/login.dart';
//
// class BuildIntroSlide extends StatelessWidget {
//   const BuildIntroSlide({
//     super.key,
//     required this.context,
//     required this.image,
//     required this.title,
//     required this.description,
//   });
//
//   final BuildContext context;
//   final String image;
//   final String title;
//   final String description;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Image section
//         SizedBox(
//           height: MediaQuery.of(context).size.height * 0.8,
//           width: MediaQuery.of(context).size.width,
//           child: Image.asset(
//             image,
//             fit: BoxFit.cover,
//           ),
//         ),
//         // Skip button
//         Positioned(
//           top: 40,
//           right: 20,
//           child: TextButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginScreen()),
//               );
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.green[800],
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//             ),
//             child: const Text(
//               'Skip',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//         // Text and button section
//         Align(
//           alignment: Alignment.bottomCenter,
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.34,
//             width: MediaQuery.of(context).size.width,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
//             decoration: BoxDecoration(
//               color: Colors.green[700],
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(20),
//                 topRight: Radius.circular(20),
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   title,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   description,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
