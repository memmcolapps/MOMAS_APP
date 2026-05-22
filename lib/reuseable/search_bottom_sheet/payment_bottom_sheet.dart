import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/domain/repository/payment_repository.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:momaspayplus/utils/strings.dart';

import '../../bloc/payment_bloc/payment_bloc.dart';
import '../../bloc/payment_bloc/payment_event.dart';
import '../../bloc/payment_bloc/payment_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/data/response/user_model.dart';
import '../../utils/keyboard_utils.dart';
import '../../core/storage/shared_pref.dart';
import '../app_error_display.dart';
import '../error_modal.dart';

class PaymentBottomSheet extends StatefulWidget {
  final String amount;
  final ServiceType? service;

  final Function(String ref)? onPayment;

  const PaymentBottomSheet(
      {super.key, required this.amount, this.onPayment, this.service});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  late PaymentBloc paymentBloc;
  String ref = DateTime.now().millisecondsSinceEpoch.toString();
  User? user;

  @override
  void initState() {
    super.initState();
    load();
    paymentBloc = PaymentBloc(PaymentRepository());
  }

  bool isLoading = false;

  void _onPaymentOptionTap(PaymentType type) {
    setState(() {
      isLoading = true;
    });
    paymentBloc.add(
      MakePayment(
          payType: type, amount: widget.amount, serviceType: widget.service!),
    );
  }

  void _onPaymentVerified(String ref) {
    setState(() {
      isLoading = true;
    });
    paymentBloc.add(VerifyPayment(ref: ref));
  }

  load() async {
    user = await SharedPreferenceHelper.getUser();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.heightOf(context);
    final EdgeInsets safePadding = MediaQuery.paddingOf(context);
    return BlocProvider(
      create: (context) => PaymentBloc(PaymentRepository()),
      child: BlocConsumer<PaymentBloc, PaymentState>(
        bloc: paymentBloc,
        builder: (context, state) {
          if (state is PaymentLoading) {

            return SizedBox(
              height: deviceHeight * 0.5,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(
                    color: MoColors.mainColor,
                    size: 40.0,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Just a moment...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, safePadding.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Choose preferred payment gateway',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'To pay',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Services',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'NGN${widget.amount ?? ''}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      widget.service?.name ?? "",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // if (appFlavor == 'development' || appFlavor == 'staging') ... [
                //   _buildPaymentOption(context, 'Pay with Test', MoImage.payStack,
                //       onTap: () {
                //         widget.onPayment!(ref);
                //         Navigator.pop(context);
                //         // _onPaymentOptionTap(PaymentType.paystack),
                //       }, additionalInfo: "1.5% + NGN100"),
                // ],
                const SizedBox(height: 10),
                _buildPaymentOption(
                    context, 'Pay with Paystack', MoImage.payStack,
                    onTap: () => _onPaymentOptionTap(PaymentType.paystack),
                    additionalInfo: "2.5% + NGN100"),
                // const SizedBox(height: 10),F
                // _buildPaymentOption(context, 'Enkpay payment', null,
                //     onTap: () => _onPaymentOptionTap(PaymentType.enkpay),
                //     additionalInfo: "Flat NGN100"),
                // const SizedBox(height: 10),
                // _buildPaymentOption(
                //     context, 'Pay with Flutterwave', MoImage.flutterWave,
                //     additionalInfo: "2.0%",
                //     onTap: () => _onPaymentOptionTap(PaymentType.flutterwave)),
                const SizedBox(height: 10),   
                _buildPaymentOption(
                    context, 'Pay with wallet', MoImage.walletPayment,
                    additionalInfo: isNotEmpty(user?.mainWallet.toString())
                        ? ' Balance: NGN ${user?.mainWallet}.'
                        : "",
                    onTap: () => _onPaymentOptionTap(PaymentType.wallet)),
              ],
            ),
          );
        },
        listener: (BuildContext context, PaymentState state) {
          if (state is PaymentSuccess) {
            setState(() {
              isLoading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentWebView(url: state.url)),
            ).then((value) {
              if (value != null && value["ref"] != null) {
                _onPaymentVerified(value["ref"]);
              }
            });
          } else if (state is PaymentVerified) {
            if (state.paymentStatus == 'success' && state.ref.isNotEmpty) {
              Navigator.pop(context);
              widget.onPayment!(state.ref);
            } else {
              // Context is still valid — show error directly without delay so the
              // user sees it before this bottom sheet is dismissed.
              showErrorBottomSheet(context, "Payment verification failed. Please try again.");
            }
          } else if (state is PaymentWalletSuccess) {
            widget.onPayment!(state.ref);
            Navigator.pop(context);
          } else if (state is PaymentFailure) {
            setState(() {
              isLoading = false;
            });
            // Context is still valid here — show error directly on the payment
            // sheet (the user can retry or close manually). Popping first would
            // unmount the context, making any subsequent error display fail silently.
            showErrorBottomSheet(context, state.error);
          }
        },
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, String title, String? iconUrl,
      {bool isSelected = false, String? additionalInfo, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: iconUrl == null
              ? CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    title.isNotEmpty ? title[0].toUpperCase() : '',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : Image.asset(
                  iconUrl,
                  width: 40,
                  height: 40,
                ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: additionalInfo != null
              ? Text(
                  additionalInfo,
                  style: const TextStyle(color: Colors.grey),
                )
              : null,
          onTap: () {
            if (onTap != null) {
              onTap();
            }
          },
        ),
      ),
    );
  }
}

class PaymentWebView extends StatefulWidget {
  final String url;

  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    loadController();
  }

  late WebViewController controller;

  // Future<void> handleApiRedirect(BuildContext context, String apiUrl) async {
  //   var client = HttpClient();
  //
  //   try {
  //     var request = await client.getUrl(Uri.parse(apiUrl));
  //     request.headers.set("ngrok-skip-browser-warning", "true");
  //     request.followRedirects = false;
  //     var response = await request.close();
  //
  //     if (response.statusCode >= 300 && response.statusCode < 400 ) {
  //       String? redirectUrl = response.headers.value('location');
  //       print(redirectUrl);
  //
  //       bool containsPayment = redirectUrl.toString().contains('payment');
  //       if (redirectUrl != null && containsPayment) {
  //         Uri uri = Uri.parse(redirectUrl);
  //         print('Query params: ${uri.queryParameters}');
  //
  //         String? ref =
  //             uri.queryParameters['ref'] ?? uri.queryParameters["trans_id"];
  //         String? status = uri.queryParameters['status'];
  //         if (context.mounted) {
  //           Navigator.pop(context, {"ref": ref, "status": status});
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   } finally {
  //     client.close();
  //   }
  // }

  loadController() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            isLoading = true;
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                isLoading = false;
              });
            }
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            Uri uri = Uri.parse(request.url);

            // if (request.url.contains('paystack-check')) {
            //   handleApiRedirect(context, request.url);
            //   return NavigationDecision.prevent;
            // }

            // bool containsPayment = uri.toString().contains('payment');
            // if (containsPayment == true) {
            //   debugPrint("Payment verification route detected");
            //   String? ref =
            //       uri.queryParameters['ref'] ?? uri.queryParameters["trans_id"];
            //   String? status = uri.queryParameters['status'];
            //   Navigator.pop(context, {"ref": ref, "status": status});
            //   return NavigationDecision.prevent;
            // }

            bool paystackVerification =
                uri.toString().contains('paystack-check');

            if (paystackVerification) {
              String? ref = uri.queryParameters['trxref'] ??
                  uri.queryParameters["reference"];
              Navigator.pop(context, {"ref": ref});
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Make Payment',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      )),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CupertinoActivityIndicator(
                  radius: 15.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
