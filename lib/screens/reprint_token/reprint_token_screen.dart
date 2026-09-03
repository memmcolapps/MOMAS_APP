import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/time_util.dart';

import '../../bloc/momas_bloc/momas_bloc.dart';
import '../../bloc/momas_bloc/momas_event.dart';
import '../../bloc/momas_bloc/momas_state.dart';
import '../../domain/data/response/meter_payment_response.dart' hide MeterData;
import '../../domain/data/response/trx_history_response.dart';
import '../../domain/repository/bill_repository.dart';
import '../../reuseable/app_error_display.dart';
import '../../reuseable/mo_form.dart';
import '../../reuseable/mo_transaction_success_screen.dart';
import '../../utils/receipt_builder.dart';
import '../../utils/screen_utils.dart';
import '../stack_screens/stack_screen_skeleton.dart';

class ReprintTokenScreen extends StatefulWidget {
  const ReprintTokenScreen({super.key});

  @override
  State<ReprintTokenScreen> createState() => _ReprintTokenScreenState();
}

class _ReprintTokenScreenState extends State<ReprintTokenScreen> {
  late final MomasPaymentBloc bloc;
  MeterData? _reprintingTransaction;

  final TextEditingController trxController = TextEditingController();

  /// Keep transactions outside the Bloc state so they remain
  /// visible while another request is loading or fails.
  List<MeterData> transactions = [];

  @override
  void initState() {
    super.initState();

    bloc = MomasPaymentBloc(
      repository: BillRepository(),
    )..add(const MomasFailedTrxHistory());
  }

  @override
  void dispose() {
    trxController.dispose();
    bloc.close();
    super.dispose();
  }

  void _onReprint(MeterData transaction) {
    final trxId = transaction.trxId?.trim() ?? "";

    if (trxId.isEmpty) {
      AppErrorDisplay.show(
        context,
        "Transaction reference is not available",
      );
      return;
    }

    setState(() {
      _reprintingTransaction = transaction;
    });

    bloc.add(
      MomasReprintToken(
        trxId: trxId,
      ),
    );
  }

  void _removeReprintingTransaction() {
    final transaction = _reprintingTransaction;

    if (transaction == null) {
      return;
    }

    setState(() {
      transactions.removeWhere(
            (item) => item.trxId == transaction.trxId,
      );

      _reprintingTransaction = null;
    });
  }

  // void _onReprint(MeterData transaction) {
  //   final trxId = transaction.trxId?.trim() ?? "";
  //
  //   if (trxId.isEmpty) {
  //     AppErrorDisplay.show(
  //       context,
  //       "Transaction reference is not available",
  //     );
  //     return;
  //   }
  //
  //   bloc.add(
  //     MomasReprintToken(
  //       trxId: trxId,
  //     ),
  //   );
  // }

  void _onSearchTransaction() {
    final trxId = trxController.text.trim();

    if (trxId.isEmpty) {
      AppErrorDisplay.show(
        context,
        "Please enter a transaction reference",
      );
      return;
    }

    bloc.add(
      MomasReprintToken(
        trxId: trxId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      // heading: "Reprint Token",
      heading: "Reprint Token",
      // trailing: IconButton(
      //   onPressed: isLoading
      //       ? null
      //       : () {
      //     bloc.add(
      //       const MomasFailedTrxHistory(),
      //     );
      //   },
      //   icon: const Icon(Icons.refresh),
      // ),
      body: BlocConsumer<MomasPaymentBloc, MomasPaymentState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is MomasPaymentFailure) {

            _removeReprintingTransaction();
            AppErrorDisplay.show(
              context,
              state.error,
            );
          }

          if (state is MomasFailedTransactionSuccess) {

            final responseTransactions =
                state.response.data?.transactions ?? [];

            setState(() {
              transactions = responseTransactions;
            });
          }

          if (state is MomasReprintTokenSuccess) {

            final receipt = state.response.data?.receipt;

            if (receipt == null) {
              AppErrorDisplay.show(
                context,
                "Receipt information is unavailable",
              );
              // IMPORTANT:
              // Only remove the transaction if the failed operation
              // was REPRINT TOKEN.
              if (_reprintingTransaction != null) {
                _removeReprintingTransaction();
              }
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TransactionSuccessPage(
                  details: ReceiptBuilder().meterPayment(
                    receipt,
                  ),
                  meterNo: receipt.meterNo,
                  token: receipt.token,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is MomasPaymentLoading;

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: context.isTablet
                        ? EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.15,
                          )
                        : EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Transaction reference:",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: MoFormWidget(
                                controller: trxController,
                                hintText: "e.g MOMAS-34r6508-8tu50",
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: IconButton(
                                onPressed:
                                    isLoading ? null : _onSearchTransaction,
                                icon: const Icon(
                                  Icons.forward,
                                  size: 20,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MoColors.mainColor,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey.shade400,
                                  disabledForegroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
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
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: transactions.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 50,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "No pending transactions found",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                OutlinedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          bloc.add(
                                            const MomasFailedTrxHistory(),
                                          );
                                        },
                                  icon: const Icon(
                                    Icons.refresh,
                                    size: 18,
                                  ),
                                  label: const Text(
                                    "Refresh",
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: MoColors.mainColor,
                                    side: const BorderSide(
                                      color: MoColors.mainColor,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              bloc.add(
                                const MomasFailedTrxHistory(),
                              );

                              // Give Bloc a moment to process the event.
                              await Future.delayed(
                                const Duration(milliseconds: 500),
                              );
                            },
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];

                                return TxrCard(
                                  transaction: transaction,
                                  onReprint: () {
                                    _onReprint(transaction);
                                  },
                                );
                              },
                            ),
                          ),
                  ),
                  // Expanded(
                  //   child: transactions.isEmpty
                  //       ? const Center(
                  //           child: Text(
                  //             "No transaction found",
                  //             style: TextStyle(
                  //               color: Colors.grey,
                  //               fontSize: 14,
                  //             ),
                  //           ),
                  //         )
                  //       : ListView.builder(
                  //           padding: const EdgeInsets.only(
                  //             bottom: 20,
                  //           ),
                  //           itemCount: transactions.length,
                  //           itemBuilder: (context, index) {
                  //             final transaction = transactions[index];
                  //
                  //             return TxrCard(
                  //               transaction: transaction,
                  //               onReprint: () {
                  //                 _onReprint(transaction);
                  //               },
                  //             );
                  //           },
                  //         ),
                  // ),
                ],
              ),
              if (isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.25,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 24,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 20,
                              spreadRadius: 2,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SpinKitFadingCircle(
                              color: MoColors.mainColorII,
                              size: 45,
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Processing...",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class TxrCard extends StatelessWidget {
  final MeterData transaction;
  final VoidCallback onReprint;

  const TxrCard({
    super.key,
    required this.transaction,
    required this.onReprint,
  });

  Color _statusColor(String? status) {
    switch ((status ?? "").toLowerCase()) {
      case "success":
      case "completed":
        return Colors.green;

      case "service_pending":
      case "payment_pending":
      case "token_pending":
      case "pending":
        return Colors.orange;

      case "failed":
      case "payment_failed":
      case "service_failed":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String? status) {
    if (status == null || status.trim().isEmpty) {
      return "UNKNOWN";
    }

    return status
        .replaceAll("_", " ")
        .split(" ")
        .map(
          (word) => word.isEmpty
              ? word
              : "${word[0].toUpperCase()}${word.substring(1)}",
        )
        .join(" ");
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _statusColor(transaction.status);

    final String status = _formatStatus(transaction.status);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                // Container(
                //   width: 40,
                //   height: 40,
                //   decoration: BoxDecoration(
                //     color: MoColors.mainColor.withOpacity(0.10),
                //     borderRadius:
                //     BorderRadius.circular(13),
                //   ),
                //   child: Icon(
                //     Icons.receipt_long,
                //     color: MoColors.mainColor,
                //     size: 20,
                //   ),
                // ),

                // const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.trxId ?? "N/A",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            TimeUtil.formatMMMMDY(
                              transaction.createdAt ?? "N/A",
                            ),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () async {
                              final trxId = transaction.trxId?.trim() ?? "N/A";

                              if (trxId.isEmpty) {
                                return;
                              }

                              await Clipboard.setData(
                                ClipboardData(text: trxId),
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Transaction reference: " +
                                          transaction.trxId.toString() +
                                          "\n copied!",
                                    ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.copy_outlined,
                                size: 17,
                                color: MoColors.mainColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),
            _infoRow(
              "Service Type",
              transaction.serviceType ?? "N/A",
            ),
            const SizedBox(height: 11),
            _infoRow(
              "Payment Type",
              transaction.payType ?? "N/A",
            ),
            const SizedBox(height: 11),
            _infoRow(
              "Meter Number",
              transaction.meterNo ?? "N/A",
            ),
            const SizedBox(height: 11),
            _infoRow(
              "Amount",
              "NGN " + transaction.amount.toString() ?? "N/A",
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onReprint,
                icon: const Icon(
                  Icons.print_outlined,
                  size: 19,
                ),
                label: const Text(
                  "Reprint Token",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MoColors.mainColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======================================================================
  // INFORMATION ROW
  // ======================================================================

  Widget _infoRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}

// class ReprintTokenScreen extends StatefulWidget {
//   const ReprintTokenScreen({super.key});
//
//   @override
//   State<ReprintTokenScreen> createState() => _ReprintTokenScreenState();
// }
//
// class _ReprintTokenScreenState extends State<ReprintTokenScreen> {
//   late final MomasPaymentBloc bloc;
//   final TextEditingController trxController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//
//     bloc = MomasPaymentBloc(
//       repository: BillRepository(),
//     )..add(const MomasFailedTrxHistory());
//   }
//
//   @override
//   void dispose() {
//     trxController.dispose();
//     bloc.close();
//     super.dispose();
//   }
//
//   void _onReprint(MeterData transaction) {
//     bloc.add(
//       MomasReprintToken(
//         trxId: transaction.trxId ?? "",
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StackScreenSkeleton(
//       heading: "Reprint Token",
//       body: BlocConsumer<MomasPaymentBloc, MomasPaymentState>(
//         bloc: bloc,
//         listener: (context, state) {
//           if (state is MomasPaymentFailure) {
//             AppErrorDisplay.show(context, state.error);
//           }
//         },
//         builder: (context, state) {
//           return Column(
//             children: [
//               Padding(
//                 padding: context.isTablet
//                     ? EdgeInsets.symmetric(
//                     horizontal:
//                     MediaQuery.of(context).size.width * .15)
//                     : EdgeInsets.zero,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 10),
//
//                     const Text(
//                       "Transaction reference:",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 5,
//                           child: MoFormWidget(
//                             controller: trxController,
//                             hintText:
//                             "e.g MOMAS-34r6508-8tu50",
//                           ),
//                         ),
//
//                         const SizedBox(width: 8),
//
//                         Expanded(
//                           child: IconButton(
//                             onPressed: () {
//                               if (trxController.text.trim().isEmpty) {
//                                 return;
//                               }
//
//                               bloc.add(
//                                 MomasReprintToken(
//                                   trxId: trxController.text.trim(),
//                                 ),
//                               );
//                             },
//                             icon: const Icon(Icons.forward),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: MoColors.mainColor,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 14, horizontal: 0.0),
//                                 elevation: 0,
//                                 side: BorderSide(color: MoColors.mainColor),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                           ),
//                           //                         Expanded(
// //                             flex: 1,
// //                             child: IconButton(
// //                               onPressed:
// //                                   () {}, //_isSharingPdf ? null : _shareAsPdf,
// //                               // icon: _isSharingPdf
// //                               //     ? const Center(
// //                               //     child: SpinKitFadingCircle(
// //                               //       color: MoColors.mainColor,
// //                               //       size: 30.0,
// //                               //     )
// //                               // )
// //                               //     :
// //                               icon: const Icon(Icons.forward,
// //                                   size: 18), //const Text("Share PDF"),
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: MoColors.mainColor,
// //                                 foregroundColor: Colors.white,
// //                                 padding: const EdgeInsets.symmetric(
// //                                     vertical: 14, horizontal: 0.0),
// //                                 elevation: 0,
// //                                 side: BorderSide(color: MoColors.mainColor),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 ),
// //                               ),
// //                             )),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               Expanded(
//                 child: Builder(
//                   builder: (_) {
//                     if (state is MomasPaymentLoading) {
//                       return const Center(
//                         child: SpinKitFadingCircle(
//                           color: MoColors.mainColorII,
//                           size: 45,
//                         ),
//                       );
//                     }
//
//                     if (state is MomasFailedTransactionSuccess) {
//                       final transactions = state
//                           .response
//                           .data
//                           ?.transactions ??
//                           [];
//
//                       if (transactions.isEmpty) {
//                         return const Center(
//                           child: Text("No transaction found"),
//                         );
//                       }
//
//                       return ListView.builder(
//                         itemCount: transactions.length,
//                         itemBuilder: (_, index) {
//                           return TxrCard(
//                             transaction: transactions[index],
//                             onReprint: () {
//                               _onReprint(transactions[index]);
//                             },
//                           );
//                         },
//                       );
//                     }
//
//                     if(state is MomasReprintTokenSuccess) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (builder) => TransactionSuccessPage(
//                               details: ReceiptBuilder().meterPayment(
//                                   state.response.data!.receipt!),
//                               meterNo: state.response.data!.receipt!.meterNo,
//                               token: state.response.data!.receipt!.token,
//                             ),
//                           ),
//                         );
//                     }
//
//                     return const Center(
//                       child: Text("No transaction found"),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
//
// class TxrCard extends StatelessWidget {
//   final MeterData transaction;
//   final VoidCallback onReprint;
//
//   const TxrCard({
//     super.key,
//     required this.transaction,
//     required this.onReprint,
//   });
//
//   Color _statusColor(String? status) {
//     switch ((status ?? "").toLowerCase()) {
//       case "success":
//       case "completed":
//         return Colors.green;
//
//       case "service_pending":
//       case "payment_pending":
//       case "token_pending":
//       case "pending":
//         return Colors.orange;
//
//       case "failed":
//         return Colors.red;
//
//       default:
//         return Colors.grey;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _statusColor(transaction.status);
//
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       elevation: 4,
//       shadowColor: Colors.black12,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           children: [
//
//             /// Header
//             Row(
//               children: [
//
//                 // CircleAvatar(
//                 //   radius: 24,
//                 //   backgroundColor: Colors.green.shade50,
//                 //   child: const Icon(
//                 //     Icons.receipt_long,
//                 //     color: Colors.green,
//                 //     size: 28,
//                 //   ),
//                 // ),
//
//                 // const SizedBox(width: 14),
//
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//
//                       Text(
//                         transaction.trxId ?? "-",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//
//                       const SizedBox(height: 4),
//
//                       Text(
//                         TimeUtil.formatMMMMDY(
//                           transaction.createdAt ?? "",
//                         ),
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: 12,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 7,
//                   ),
//                   decoration: BoxDecoration(
//                     color: statusColor.withOpacity(.15),
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text(
//                     transaction.status ?? "",
//                     style: TextStyle(
//                       color: statusColor,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 10,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//
//             // const SizedBox(height: 20),
//             //
//             // const Divider(),
//             //
//             const SizedBox(height: 10),
//
//             _infoRow(
//               // Icons.electrical_services,
//               "Service",
//               transaction.serviceType ?? "-",
//             ),
//
//             const SizedBox(height: 10),
//
//             _infoRow(
//               // Icons.credit_card,
//               "Payment Type",
//               transaction.payType ?? "-",
//             ),
//
//             const SizedBox(height: 10),
//
//             _infoRow(
//               // Icons.speed,
//               "Meter Number",
//               transaction.meterNo ?? "-",
//             ),
//
//             const SizedBox(height: 20),
//
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: onReprint,
//                 icon: const Icon(Icons.print),
//                 label: const Text(
//                   "Reprint Token",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   padding:
//                   const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _infoRow(
//       // IconData icon,
//       String title,
//       String value,
//       ) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//
//         // Icon(
//         //   icon,
//         //   color: Colors.grey,
//         //   size: 18,
//         // ),
//
//         // const SizedBox(width: 10),
//
//         Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//
//         const Spacer(),
//
//         Flexible(
//           child: Text(
//             value,
//             textAlign: TextAlign.end,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontWeight: FontWeight.normal,
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

///-----
//
// class ReprintTokenScreen extends StatefulWidget {
//   ReprintTokenScreen({super.key});
//
//   @override
//   State<ReprintTokenScreen> createState() => _ReprintTokenScreenState();
// }
//
// class _ReprintTokenScreenState extends State<ReprintTokenScreen> {
//   late MomasPaymentBloc bloc;
//   // List<MeterData>? meterDataList = [];
//   // List<MeterData>? filteredMeterDataList = [];
//   TrxHistoryResponse? trxHistoryResponse;
//
//   bool get trxData => trxHistoryResponse != null && trxHistoryResponse?.data != null;
//
//   @override
//   void initState() {
//     super.initState();
//     bloc = MomasPaymentBloc(repository: BillRepository())
//       ..add(const MomasFailedTrxHistory());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StackScreenSkeleton(
//       heading: "Reprint Token",
//       body: BlocConsumer<MomasPaymentBloc, MomasPaymentState>(
//         bloc: bloc,
//         builder: (context, state) {
//           return Column(
//             children: [
//               Padding(
//                 padding: context.isTablet
//                     ? EdgeInsets.symmetric(
//                         horizontal: MediaQuery.of(context).size.width * 0.15)
//                     : const EdgeInsets.all(0.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 10.0),
//                     const Text(
//                       'Transaction reference:',
//                       style: TextStyle(
//                           fontSize: 14.0, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 5,
//                           child: MoFormWidget(
//                             // prefixIcon:
//                             //     Icon(Icons.token_outlined, color: MoColors.mainColor),
//                             hintText: "e.g MOMAS-34r67726508-87tu500",
//                             onChange: (value) {
//                               // _filterData(value);
//                             },
//                           ),
//                         ),
//                         Expanded(
//                             flex: 1,
//                             child: IconButton(
//                               onPressed:
//                                   () {}, //_isSharingPdf ? null : _shareAsPdf,
//                               // icon: _isSharingPdf
//                               //     ? const Center(
//                               //     child: SpinKitFadingCircle(
//                               //       color: MoColors.mainColor,
//                               //       size: 30.0,
//                               //     )
//                               // )
//                               //     :
//                               icon: const Icon(Icons.forward,
//                                   size: 18), //const Text("Share PDF"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: MoColors.mainColor,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 14, horizontal: 0.0),
//                                 elevation: 0,
//                                 side: BorderSide(color: MoColors.mainColor),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             )),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               state is MomasPaymentLoading
//                   ? const Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SpinKitFadingCircle(
//                           color: MoColors.mainColorII,
//                           size: 50.0,
//                         )
//                       ],
//                     )
//                   : Expanded(
//                       child: ListView.builder(
//                         itemCount: trxHistoryResponse?.data?.transactions?.length ?? 0,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             // onTap: () {
//                             //   Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //       builder: (builder) => TransactionSuccessPage(
//                             //         details: ReceiptBuilder().meterPayment(
//                             //             trxHistoryResponse!.data!.transactions![index]),
//                             //         meterNo: filteredMeterDataList![index].meterNo,
//                             //         token: filteredMeterDataList![index].token,
//                             //       ),
//                             //     ),
//                             //   );
//                             // },
//                             child: TxrCard(transactions: trxHistoryResponse?.data?.transactions![index])
//                             // TokenCard(token: filteredMeterDataList![index]),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           );
//         },
//         listener: (BuildContext context, MomasPaymentState state) {
//           if (state is MomasPaymentFailure) {
//             AppErrorDisplay.show(context, state.error);
//           } else if (state is MomasFailedTransactionSuccess) {
//             setState(() {
//               trxHistoryResponse = state.response;
//             });
//             // meterDataList = state.response.data?.transactions;
//             // meterDataList = state.meterPaymentResponse.data;
//             // filteredMeterDataList = List.from(meterDataList!);
//           } else {}
//         },
//       ),
//     );
//   }
// }
//
// class TxrCard extends StatelessWidget {
//   final MeterData? transactions;
//
//   const TxrCard({super.key, required this.transactions});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//       child: ShadowContainer(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 16,
//                     backgroundColor: Colors.green[100],
//                     child: const Icon(
//                       Icons.receipt,
//                       color: Colors.green,
//                       size: 15,
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${transactions?.trxId}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(transactions?.payType ?? "",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12.0,
//                           )),
//                     ],
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       TimeUtil.formatMMMMDY(transactions?.createdAt ?? ""),
//                       style: const TextStyle(fontSize: 10),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       AmountFormatter.formatNaira(
//                         double.tryParse(transactions?.amount ?? "0") ?? 0,
//                       ),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
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

///-------------------

// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:momaspayplus/reuseable/mo_button.dart';
// import 'package:momaspayplus/utils/colors.dart';
// import 'package:momaspayplus/utils/time_util.dart';
//
// import '../../bloc/momas_bloc/momas_bloc.dart';
// import '../../bloc/momas_bloc/momas_event.dart';
// import '../../bloc/momas_bloc/momas_state.dart';
// import '../../domain/data/response/meter_payment_response.dart';
// import '../../domain/repository/bill_repository.dart';
// import '../../reuseable/app_error_display.dart';
// import '../../reuseable/error_modal.dart';
// import '../../reuseable/mo_form.dart';
// import '../../reuseable/mo_transaction_success_screen.dart';
// import '../../reuseable/pop_button.dart';
// import '../../reuseable/shadow_container.dart';
// import '../../utils/amount_formatter.dart';
// import '../../utils/receipt_builder.dart';
// import '../../utils/screen_utils.dart';
// import '../stack_screens/stack_screen_skeleton.dart';
//
// class ReprintTokenScreen extends StatefulWidget {
//   ReprintTokenScreen({super.key});
//
//   @override
//   State<ReprintTokenScreen> createState() => _ReprintTokenScreenState();
// }
//
// class _ReprintTokenScreenState extends State<ReprintTokenScreen> {
//   late MomasPaymentBloc bloc;
//   List<MeterData>? meterDataList = [];
//   List<MeterData>? filteredMeterDataList = [];
//
//   @override
//   void initState() {
//     bloc = MomasPaymentBloc(repository: BillRepository())
//       ..add(const MomasPaymentHistory());
//     super.initState();
//   }
//
//   // void _filterData(String query) {
//   //   if (query.isEmpty) {
//   //     setState(() {
//   //       filteredMeterDataList = List.from(meterDataList!);
//   //     });
//   //   } else {
//   //     setState(() {
//   //       filteredMeterDataList = meterDataList!.where((data) {
//   //         return data.token!.contains(query) || data.orderId!.contains(query);
//   //       }).toList();
//   //     });
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return StackScreenSkeleton(
//       heading: "Reprint Token",
//       body: BlocConsumer<MomasPaymentBloc, MomasPaymentState>(
//         bloc: bloc,
//         builder: (context, state) {
//           return Column(
//             children: [
//               // const SizedBox(height: 13),
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(horizontal: 15),
//               //   child: Center(
//               //     child: ShadowContainer(
//               //       child: Padding(
//               //         padding: const EdgeInsets.symmetric(
//               //             vertical: 10, horizontal: 8),
//               //         child: SizedBox(
//               //           height: 40,
//               //           width: MediaQuery.of(context).size.width - 15,
//               //           child: Row(
//               //             children: [
//               //               PopButton().pop(context),
//               //               const SizedBox(width: 20),
//               //               const Text("Make Payment for MOMAS"),
//               //             ],
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               // const SizedBox(height: 20),
//
//
//               Padding(
//                 padding: context.isTablet
//                     ? EdgeInsets.symmetric(
//                     horizontal: MediaQuery.of(context).size.width * 0.15)
//                     : const EdgeInsets.all(0.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 10.0),
//                     const Text(
//                       'Transaction reference:',
//                       style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 10.0),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 5,
//                           child: MoFormWidget(
//                             // prefixIcon:
//                             //     Icon(Icons.token_outlined, color: MoColors.mainColor),
//                             hintText: "e.g MOMAS-34r67726508-87tu500",
//                             onChange: (value) {
//                               // _filterData(value);
//                             },
//                           ),
//                         ),
//                         Expanded(
//                             flex:1,
//                             child: IconButton(
//                               onPressed: (){},//_isSharingPdf ? null : _shareAsPdf,
//                               // icon: _isSharingPdf
//                               //     ? const Center(
//                               //     child: SpinKitFadingCircle(
//                               //       color: MoColors.mainColor,
//                               //       size: 30.0,
//                               //     )
//                               // )
//                               //     :
//                               icon: const Icon(
//                                   Icons.forward,
//                                   size: 18),//const Text("Share PDF"),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: MoColors.mainColor,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 14, horizontal: 0.0),
//                                 elevation: 0,
//                                 side: BorderSide(color: MoColors.mainColor),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                             )
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               state is MomasPaymentLoading
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SpinKitFadingCircle(
//                           color: MoColors.mainColorII,
//                           size: 50.0,
//                         )
//                       ],
//                     )
//                   : Expanded(
//                       child: ListView.builder(
//                         itemCount: filteredMeterDataList?.length ?? 0,
//                         itemBuilder: (context, index) {
//                           return InkWell(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (builder) =>
//                                       TransactionSuccessPage(
//                                     details: ReceiptBuilder().meterHistory(
//                                         filteredMeterDataList![index]),
//                                     meterNo: filteredMeterDataList![index].meterNo,
//                                     token: filteredMeterDataList![index].token,
//                                   ),
//                                 ),
//                               );
//                             },
//                             child: TokenCard(
//                                 token: filteredMeterDataList![index]),
//                           );
//                         },
//                       ),
//                     ),
//             ],
//           );
//         },
//         listener: (BuildContext context, MomasPaymentState state) {
//           if (state is MomasPaymentFailure) {
//             AppErrorDisplay.show(context, state.error);
//           } else if (state is MomasMeterSuccess) {
//             meterDataList = state.meterPaymentResponse.data;
//             filteredMeterDataList = List.from(meterDataList!);
//           } else {
//           }
//         },
//       ),
//     );
//   }
// }
//
// class TokenCard extends StatelessWidget {
//   final MeterData token;
//
//   const TokenCard({super.key, required this.token});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//       child: ShadowContainer(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 16,
//                     backgroundColor: Colors.green[100],
//                     child: const Icon(
//                       Icons.receipt,
//                       color: Colors.green,
//                       size: 15,
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "${token.orderId}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15.0,
//                         ),
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Text(token.token ?? "",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12.0,
//                           )),
//                     ],
//                   ),
//                 ],
//               ),
//               const Spacer(),
//               Expanded(
//                 flex: 2,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       TimeUtil.formatMMMMDY(token.createdAt ?? ""),
//                       style: const TextStyle(fontSize: 10),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       AmountFormatter.formatNaira(token.amount!.toDouble()),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.0,
//                       ),
//                     ),
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
