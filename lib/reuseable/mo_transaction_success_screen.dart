// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
// import 'package:momaspayplus/reuseable/shadow_container.dart';
// import 'package:momaspayplus/tabs/root_screen.dart';
// import 'package:momaspayplus/utils/colors.dart';
// import 'package:momaspayplus/utils/navigation.dart';
// import 'package:screenshot/screenshot.dart';
// import 'package:share_plus/share_plus.dart';
// import 'dart:typed_data';
//
// import '../domain/data/transaction_details.dart';
// import '../screens/dashboard/root_screen.dart';
// import '../utils/images.dart';
// import 'package:path_provider/path_provider.dart' as path;
//
// import '../utils/strings.dart';
//
// class TransactionSuccessPage extends StatefulWidget {
//   final String? successMessage;
//   final String? receiptHeading;
//   final List<TransactionDetail>? details;
//   final bool failed;
//
//   const TransactionSuccessPage(
//       {super.key,
//       this.successMessage,
//       this.receiptHeading,
//       this.details,
//       this.failed = false});
//
//   @override
//   State<TransactionSuccessPage> createState() => _TransactionSuccessPageState();
// }
//
// class _TransactionSuccessPageState extends State<TransactionSuccessPage> {
//   late ScreenshotController screenshotController;
//
//   @override
//   void initState() {
//     screenshotController = ScreenshotController();
//     super.initState();
//   }
//
//   Future<void> _takeScreenshot() async {
//     try {
//       screenshotController
//           .capture(delay: const Duration(milliseconds: 10))
//           .then((capturedImage) async {
//         if (capturedImage != null) {
//           final directory = await path.getApplicationDocumentsDirectory();
//           final imagePath =
//               await File('${directory.path}/screenshot.png').create();
//           await imagePath.writeAsBytes(capturedImage);
//
//           await Share.shareXFiles([XFile(imagePath.path)],
//               text: 'Here is your receipt!');
//         }
//         // ShowCapturedWidget(context, capturedImage!);
//       }).catchError((onError) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to share')),
//         );
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to share : $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[200],
//         body: Container(
//           color: MoColors.mainColor.withOpacity(0.2),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Screenshot(
//                   controller: screenshotController,
//                   child: Container(
//                     color: MoColors.mainColor.withOpacity(0.2),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 15),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.1,
//                               child: widget.failed == true
//                                   ? Lottie.asset(MoImage.error, repeat: true)
//                                   : Lottie.asset(MoImage.lottieSuccess,
//                                       repeat: true)),
//                           const SizedBox(height: 16.0),
//                           widget.failed == true
//                               ? const Text(
//                                   'Payment Failed(Retry)',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.red,
//                                   ),
//                                 )
//                               : Text(
//                                   widget.successMessage != null
//                                       ? widget.successMessage!
//                                       : "Payment Successful",
//                                   style: const TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                           const SizedBox(height: 16.0),
//                           ReceiptWidget(
//                             details: widget.details ?? [],
//                             receiptHeading: widget.receiptHeading,
//                           ),
//                           const SizedBox(height: 16.0),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 color: MoColors.mainColor.withOpacity(0.2),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             NavigationService.navigatorKey.currentState?.popUntil((route) => route.isFirst);
//                             context.read<TabCubit>().changeTab(0);
//                           },
//                           // onTap: () => Navigator.of(context).pushAndRemoveUntil(
//                           //     MaterialPageRoute(
//                           //         builder: (context) => const RootScreen()),
//                           //     (route) => false),
//                           child: ShadowContainer(
//                               color: MoColors.mainColor,
//                               borderRadius: BorderRadius.circular(8),
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12.0, horizontal: 15),
//                                 child: Icon(Icons.home_filled,
//                                     color: Colors.white),
//                               )),
//                         ),
//                         InkWell(
//                           onTap: () => _takeScreenshot(),
//                           child: ShadowContainer(
//                               color: MoColors.mainColor,
//                               borderRadius: BorderRadius.circular(8),
//                               child: const Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 12.0, horizontal: 15),
//                                 child: Icon(Icons.share, color: Colors.white),
//                               )),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16.0),
//                     // ElevatedButton(
//                     //   onPressed: () {},
//                     //   style: ElevatedButton.styleFrom(
//                     //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     //   ),
//                     //   child: const Text('LEARN HOW TO ACTIVATE TOKEN'),
//                     // ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height * 0.1,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Future<dynamic> ShowCapturedWidget(
//     BuildContext context, Uint8List capturedImage) {
//   return showDialog(
//     useSafeArea: false,
//     context: context,
//     builder: (context) => Scaffold(
//       appBar: AppBar(
//         title: Text("Captured widget screenshot"),
//       ),
//       body: Center(child: Image.memory(capturedImage)),
//     ),
//   );
// }
//
// class ReceiptWidget extends StatelessWidget {
//   final List<TransactionDetail> details;
//   final String? receiptHeading;
//
//   const ReceiptWidget({super.key, required this.details, this.receiptHeading});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.9,
//         decoration: BoxDecoration(
//           color: MoColors.mainColor.withOpacity(0.01),
//           borderRadius: BorderRadius.circular(10.0),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: ClipPath(
//           clipper: ReceiptClipper(),
//           child: Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     receiptHeading != null
//                         ? receiptHeading!
//                         : 'Purchase Details',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20.0,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 ...details.where((detail) => isNotEmpty(detail.value)).map(
//                     (detail) =>
//                         buildDetailRow(detail.label ?? "", detail.value ?? "")),
//                 const SizedBox(height: 16.0),
//                 const Center(
//                   child: Text(
//                     'Thank you for choosing momas pay',
//                     style: TextStyle(
//                       fontStyle: FontStyle.italic,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDetailRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 3.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.grey,
//               fontSize: 16.0,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               textAlign: TextAlign.end,
//               style: const TextStyle(
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ReceiptClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     var path = Path();
//     double cutSize = 8.0;
//
//     path.moveTo(0, cutSize);
//     for (double i = cutSize; i < size.width; i += 2 * cutSize) {
//       path.lineTo(i, 0);
//       path.lineTo(i + cutSize, cutSize);
//     }
//     path.lineTo(size.width, cutSize);
//     path.lineTo(size.width, size.height - cutSize);
//     for (double i = size.width - cutSize; i > 0; i -= 2 * cutSize) {
//       path.lineTo(i, size.height);
//       path.lineTo(i - cutSize, size.height - cutSize);
//     }
//     path.lineTo(0, size.height - cutSize);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }


import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/navigation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

import '../domain/data/transaction_details.dart';
import '../utils/images.dart';
import '../utils/strings.dart';

class TransactionSuccessPage extends StatefulWidget {
  final String? successMessage;
  final String? receiptHeading;
  final List<TransactionDetail>? details;
  final bool failed;

  const TransactionSuccessPage({
    super.key,
    this.successMessage,
    this.receiptHeading,
    this.details,
    this.failed = false,
  });

  @override
  State<TransactionSuccessPage> createState() => _TransactionSuccessPageState();
}

class _TransactionSuccessPageState extends State<TransactionSuccessPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

  void _goHome() {
    NavigationService.navigatorKey.currentState
        ?.popUntil((route) => route.isFirst);
    context.read<TabCubit>().changeTab(0);
  }

  Future<Uint8List> _buildPdf() async {
    final pdf = pw.Document();
    final logoBytes = await rootBundle.load(MoImage.logoTransparent);
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());
    final details = widget.details ?? [];

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(logoImage, width: 80, height: 80),
              pw.SizedBox(height: 8),
              pw.Text(
                'MOMASPay',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#28B446'),
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: pw.BoxDecoration(
                  color: widget.failed
                      ? PdfColor.fromHex('#FFEBEE')
                      : PdfColor.fromHex('#E8F8EC'),
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  widget.failed ? 'Payment Failed' : 'Payment Successful',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: widget.failed
                        ? PdfColor.fromHex('#D32F2F')
                        : PdfColor.fromHex('#28B446'),
                  ),
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Text(
                widget.receiptHeading ?? 'Purchase Details',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Divider(color: PdfColor.fromHex('#E0E0E0')),
              pw.SizedBox(height: 8),
              ...details
                  .where((d) => isNotEmpty(d.value))
                  .map(
                    (d) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  child: pw.Row(
                    mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        d.label ?? '',
                        style: const pw.TextStyle(
                          color: PdfColors.grey600,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        d.value ?? '',
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Divider(color: PdfColor.fromHex('#E0E0E0')),
              pw.SizedBox(height: 8),
              pw.Text(
                'Thank you for choosing Momas Pay',
                style: pw.TextStyle(
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _shareAsPdf() async {
    setState(() => _isSharing = true);
    try {
      final pdfBytes = await _buildPdf();
      final dir = await path.getApplicationDocumentsDirectory();
      final file = File('${dir.path}/receipt.pdf');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _shareAsImage() async {
    setState(() => _isSharing = true);
    try {
      final image = await _screenshotController.capture(
          delay: const Duration(milliseconds: 10));
      if (image != null) {
        final dir = await path.getApplicationDocumentsDirectory();
        final file = File('${dir.path}/receipt.png');
        await file.writeAsBytes(image);
        await Share.shareXFiles([XFile(file.path)]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoColors.mainColorLight,
      body: SafeArea(
        child: Column(
          children: [
            // top bar
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: _goHome,
                    icon: const Icon(Icons.home_outlined, size: 18),
                    label: const Text("Home"),
                    style: TextButton.styleFrom(
                      foregroundColor: MoColors.mainColor,
                    ),
                  ),
                ],
              ),
            ),

            // scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // animation — outside Screenshot, won't be captured
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: widget.failed
                          ? Lottie.asset(MoImage.error, repeat: true)
                          : Lottie.asset(MoImage.lottieSuccess,
                          repeat: true),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.failed
                          ? 'Payment Failed'
                          : widget.successMessage ?? 'Payment Successful',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: widget.failed
                            ? Colors.red.shade400
                            : MoColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.failed
                          ? 'Your payment could not be processed.'
                          : 'Your transaction was completed successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 20),

                    // Screenshot only wraps the receipt card
                    Screenshot(
                      controller: _screenshotController,
                      child: _ReceiptCard(
                        details: widget.details ?? [],
                        receiptHeading: widget.receiptHeading,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // bottom actions
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: _isSharing
                  ? Center(
                child: CircularProgressIndicator(
                  color: MoColors.mainColor,
                ),
              )
                  : Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareAsImage,
                      icon: const Icon(Icons.image_outlined, size: 18),
                      label: const Text("Share Image"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MoColors.mainColor,
                        side:
                        BorderSide(color: MoColors.mainColor),
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _shareAsPdf,
                      icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 18),
                      label: const Text("Share PDF"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MoColors.mainColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final List<TransactionDetail> details;
  final String? receiptHeading;

  const _ReceiptCard({required this.details, this.receiptHeading});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ReceiptClipper(),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(MoImage.logoTransparent, height: 48),
            const SizedBox(height: 4),
            const Text(
              'MOMASPay',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: MoColors.mainColor,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 12),
            Text(
              receiptHeading ?? 'Purchase Details',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...details
                .where((d) => isNotEmpty(d.value))
                .map((d) => _buildRow(d.label ?? '', d.value ?? '')),
            const SizedBox(height: 16),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 8),
            Text(
              'Thank you for choosing Momas Pay',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 11,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cutSize = 8.0;

    path.moveTo(0, cutSize);
    for (double i = cutSize; i < size.width; i += 2 * cutSize) {
      path.lineTo(i, 0);
      path.lineTo(i + cutSize, cutSize);
    }
    path.lineTo(size.width, cutSize);
    path.lineTo(size.width, size.height - cutSize);
    for (double i = size.width - cutSize; i > 0; i -= 2 * cutSize) {
      path.lineTo(i, size.height);
      path.lineTo(i - cutSize, size.height - cutSize);
    }
    path.lineTo(0, size.height - cutSize);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}  