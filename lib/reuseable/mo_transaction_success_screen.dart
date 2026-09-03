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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
import 'package:momaspayplus/domain/data/request/set_token_request.dart';
import 'package:momaspayplus/domain/data/response/hes_connection_response.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/navigation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

import '../bloc/hes_bloc/hes_bloc.dart';
import '../bloc/hes_bloc/hes_event.dart';
import '../bloc/hes_bloc/hes_state.dart';
import '../domain/data/transaction_details.dart';
import '../domain/repository/hes_repository.dart';
import '../utils/images.dart';
import '../utils/strings.dart';
import 'app_error_display.dart';
import 'error_modal.dart';

class TransactionSuccessPage extends StatefulWidget {
  final String? successMessage;
  final String? receiptHeading;
  final List<TransactionDetail>? details;
  final bool failed;
  final String? meterNo;
  final String? token;
  const TransactionSuccessPage({
    super.key,
    this.successMessage,
    this.receiptHeading,
    this.details,
    this.failed = false, this.meterNo, this.token,
  });

  @override
  State<TransactionSuccessPage> createState() => _TransactionSuccessPageState();
}

class _TransactionSuccessPageState extends State<TransactionSuccessPage> {
  final ScreenshotController _screenshotController = ScreenshotController();

  late HesBloc hesBloc;
  @override
  void initState() {
    super.initState();
    hesBloc = HesBloc(repository: HesRepository());
  }
  // bool _isSharing = false;

  bool _isSharingImage = false;
  bool _isSharingPdf = false;
  bool _isLoadingToken = false;

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
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context ctx) {
          return pw.Stack(
            children: [
              // failed watermark diagonal text
              if (widget.failed)
                pw.Center(
                  child: pw.Transform.rotate(
                    angle: -0.5,
                    child: pw.Text(
                      'FAILED',
                      style: pw.TextStyle(
                        fontSize: 80,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#D32F2F').shade(0.08),
                      ),
                    ),
                  ),
                ),

              // main content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  // logo + name
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Image(logoImage, width: 32, height: 32),
                      pw.SizedBox(width: 8),
                      pw.Text(
                        'MOMASPay',
                        style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#28B446'),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(color: PdfColor.fromHex('#E0E0E0')),
                  pw.SizedBox(height: 12),

                  // heading
                  pw.Text(
                    widget.receiptHeading ?? 'Purchase Details',
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 12),

                  // detail rows
                  ...details
                      .where((d) => isNotEmpty(d.value))
                      .map((d) => pw.Padding(
                    padding:
                    const pw.EdgeInsets.symmetric(vertical: 6),
                    child: pw.Row(
                      mainAxisAlignment:
                      pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          d.label ?? '',
                          style: const pw.TextStyle(
                            color: PdfColors.grey600,
                            fontSize: 11,
                          ),
                        ),
                        pw.Text(
                          d.value ?? '',
                          style: pw.TextStyle(
                            fontSize: 11,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),

                  pw.SizedBox(height: 16),
                  pw.Divider(color: PdfColor.fromHex('#E0E0E0')),
                  pw.SizedBox(height: 10),

                  pw.Text(
                    'Thank you for choosing Momas Pay',
                    style: pw.TextStyle(
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _imageToPdf(Uint8List imageBytes) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context ctx) {
          return pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _shareAsPdf() async {
    setState(() => _isSharingPdf = true);
    try {
      // capture the same screenshot used for image share
      final imageBytes = await _screenshotController.capture(
          delay: const Duration(milliseconds: 10));
      if (imageBytes != null) {
        final pdfBytes = await _imageToPdf(imageBytes);
        final dir = await path.getApplicationDocumentsDirectory();
        final file = File('${dir.path}/receipt.pdf');
        await file.writeAsBytes(pdfBytes);
        await Share.shareXFiles([XFile(file.path)]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share PDF: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSharingPdf = false);
    }
  }

  Future<void> _shareAsImage() async {
    setState(() => _isSharingImage = true);
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
      if (mounted) setState(() => _isSharingImage = false);
    }
  }

  Future<void> _loadToken() async {
    setState(() => _isLoadingToken = true);

    hesBloc.add(
      HesMeter(
        serial: widget.meterNo.toString(),
      ),
    );
  }

  // Future<void> _loadToken() async {
  //   setState(() => _isLoadingToken = true);
  //   hesBloc.add(
  //     LoadToken(
  //       serial: widget.meterNo.toString(),// "62226000909",//"62526003397", //widget.meterNo.toString(),//"62525004172",
  //       token: widget.token.toString()//"20393820578721407070"// //"56502592455403497443",
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HesBloc, HesState>(
      bloc: hesBloc,
        listener: (context, state) {

          if (state is HesLoading) {
            // setState(() => _isSharing = true);
          }

          if (state is HesConnectionSuccess) {
            setState(() => _isLoadingToken = false);

            _showMeterStatusDialog(state.response);
          }

          if (state is SetTokenSuccess) {
            setState(() => _isLoadingToken = false);
            showSuccessBottomSheet(context,"Token Loaded Successful");
            // state.response.data!.status.toLowerCase().contains("success")
            //     && state.response.data!.dlmsStatus.toLowerCase().contains("success")
            //     && state.response.data!.tokenStatus!.toLowerCase().contains("success")
            //     ? showSuccessBottomSheet(context,"Token Loaded Successful")
            //     : AppErrorDisplay.show(context, "Invalid Meter or Token");
          }

          if (state is HesError) {

            setState(() => _isLoadingToken = false);

            AppErrorDisplay.show(context, state.error);
          }

        },

        builder: (context, state) {

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

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          // animation — outside Screenshot
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

                          // Screenshot wraps only the receipt card
                          Screenshot(
                            controller: _screenshotController,
                            child: _ReceiptCard(
                              details: widget.details ?? [],
                              receiptHeading: widget.receiptHeading,
                              failed: widget.failed,
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
                    child: Row(
                      children: [
                        Expanded(
                          flex:1,
                            child: IconButton(
                      onPressed: _isSharingImage ? null : _shareAsImage,
                              icon: _isSharingImage
                                  ? const Center(
                                  child: SpinKitFadingCircle(
                                    color: MoColors.mainColor,
                                    size: 30.0,
                                  )
                              )
                                  : const Icon(
                                  Icons.share,
                                  size: 18),//const Text("Share PDF"),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: MoColors.mainColor,
                                    side: BorderSide(color: MoColors.mainColor),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 0.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                            ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            flex:1,
                          child: IconButton(
                              onPressed: _isSharingPdf ? null : _shareAsPdf,
                            icon: _isSharingPdf
                                ? const Center(
                                child: SpinKitFadingCircle(
                                  color: MoColors.mainColor,
                                  size: 30.0,
                                )
                            )
                                : const Icon(
                                  Icons.download_outlined,
                                  size: 18),//const Text("Share PDF"),
                              style: ElevatedButton.styleFrom(
                                // backgroundColor: MoColors.mainColor.withOpacity(0.2),
                                foregroundColor: MoColors.mainColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 0.0),
                                elevation: 0,
                                side: BorderSide(color: MoColors.mainColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                          )
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex:2,
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingToken ? null : _loadToken,
                            icon: _isLoadingToken
                                ? const Center(
                                  child: SpinKitFadingCircle(
                                    color: MoColors.mainColor,
                                    size: 30.0,
                                  )
                            )
                                : const Icon(
                              Icons.token_outlined,
                              size: 18,
                            ),
                            label: Text(
                              _isLoadingToken ? "Loading..." : "Load Token",
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MoColors.mainColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        },
    );
  }

  Future<void> _showMeterStatusDialog(
      HesConnectionResponse response) async {

    final isOnline = response.connectionType == "ONLINE";

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("Meter Status", style: TextStyle(
              fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text("Meter number-"+widget.meterNo.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),),
              const SizedBox(height: 10,),
              Text(
                isOnline
                    ? "The meter is online. Do you want to continue loading the token?"
                    : "The meter is offline. Do you want to continue loading the token?",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),

              Align(
                alignment: AlignmentGeometry.topCenter,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isOnline ? MoColors.mainColorMid.withOpacity(0.5) : MoColors.brickRed.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child:  isOnline
                      ? Text(response.connectionType,  textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: MoColors.mainColorDark),)
                      : Text(response.connectionType,  textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15, color: MoColors.brickRed)),
                ),
              ),
            ],
          ),
          actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MoColors.brickRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        setState(() {
                          _isLoadingToken = true;
                        });

                        hesBloc.add(
                          LoadToken(
                            serial: widget.meterNo.toString(),
                            token: widget.token.toString(),
                          ),
                        );
                      },
                      child: const Text("Continue"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MoColors.mainColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final List<TransactionDetail> details;
  final String? receiptHeading;
  final bool failed;

  const _ReceiptCard({
    required this.details,
    required this.failed,
    this.receiptHeading,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ReceiptClipper(),
      child: Container(
        width: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            // failed diagonal watermark
            if (failed)
              Positioned.fill(
                child: Center(
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Text(
                      'FAILED',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w900,
                        color: Colors.red.withOpacity(0.06),
                        letterSpacing: 8,
                      ),
                    ),
                  ),
                ),
              ),

            // receipt content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // logo + name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(MoImage.logoTransparent, height: 30),
                      const SizedBox(width: 6),
                      const Text(
                        'MOMASPay',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: MoColors.mainColor,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 12),

                  // heading
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      receiptHeading ?? 'Purchase Details',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // detail rows
                  ...details
                      .where((d) => isNotEmpty(d.value))
                      .map((d) => Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.label ?? '',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            d.value ?? '',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

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
          ],
        ),
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