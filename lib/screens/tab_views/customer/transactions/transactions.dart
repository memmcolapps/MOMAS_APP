import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/reuseable/views/error_view.dart';
import 'package:momaspayplus/screens/tab_views/customer/transactions/widgets/loading_dialog.dart';
import 'package:momaspayplus/screens/tab_views/customer/transactions/widgets/skeleton_transaction_list.dart';
import 'package:momaspayplus/screens/tab_views/customer/transactions/widgets/transaction_card.dart';
import 'package:momaspayplus/screens/tab_views/shared/tabview_skeleton.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:momaspayplus/utils/strings.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../bloc/payment_bloc/payment_bloc.dart';
import '../../../../bloc/payment_bloc/payment_event.dart';
import '../../../../bloc/payment_bloc/payment_state.dart';
import '../../../../domain/data/response/transaction_data_response.dart';
import '../../../../domain/repository/payment_repository.dart';
import '../../../../reuseable/app_error_display.dart';
import '../../../../reuseable/error_modal.dart';
import '../../../../reuseable/mo_form.dart';
import '../../../../reuseable/mo_transaction_success_screen.dart';
import '../../../../reuseable/pop_button.dart';
import '../../../../reuseable/shadow_container.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/receipt_builder.dart';
import '../../../../utils/time_util.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  late PaymentBloc paymentBloc;
  List<TransactionData>? transactionDataList = [];
  List<TransactionData>? filteredTransactionDataList = [];
  @override
  void initState() {
    super.initState();
    paymentBloc = PaymentBloc(PaymentRepository())..add(const SearchPayment());
  }

  void _filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredTransactionDataList = List.from(transactionDataList!);
      });
    } else {
      setState(() {
        filteredTransactionDataList = transactionDataList!.where((data) {
          return data.payType!.contains(query) || data.trxId!.contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabViewSkeleton(
      appBarTitle: "Transactions",
      body: BlocConsumer<PaymentBloc, PaymentState>(
        bloc: paymentBloc,
        builder: (context, state) {


          if (state is PaymentFailure) {
            return ErrorView(
              message: state.error,
              onRetry: () => paymentBloc.add(const SearchPayment()),
            );
          }

          return Padding(
            padding: context.isTablet
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15)
                : const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: MoFormWidget(
                    prefixIcon: const Icon(Icons.search, color: MoColors.mainColor),
                    hintText: "Search",
                    onChange: (value) {
                      _filterData(value);
                    },
                  ),
                ),
                Expanded(
                  child: state is PaymentLoading
                      ? const SkeletonTransactionList()
                      : ListView.builder(
                          itemCount: filteredTransactionDataList?.length ?? 0,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                paymentBloc.add(ViewReceipt(
                                    filteredTransactionDataList![index]
                                        .id
                                        .toString())); // Navigator.push(
                              },
                              child: TransactionCard(
                                data: filteredTransactionDataList![index],
                                // retry: (transRef) {
                                //   paymentBloc.add(RetryPayment(transRef));
                                // },
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          );
        },
        listener: (BuildContext context, PaymentState state) {
          if (state is ReceiptLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const LoadingDialog(text: "Loading Receipt..."),
            );
          } else if (state is ReceiptFailure) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            AppErrorDisplay.show(context, state.error);
          } else if (state is ViewMomasPaymentSuccess) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
          }

          if (state is RetryLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const LoadingDialog(text: "Retrying Transaction..."),
            );
          } else if (state is RetryFailure) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            AppErrorDisplay.show(context, state.error);
          }

          if (state is PaymentHistorySuccess) {
            transactionDataList = state.data;
            filteredTransactionDataList = List.from(transactionDataList!);
          } else if (state is PaymentFailureState) {
            AppErrorDisplay.show(context, state.error);
          } else if (state is MomasPaymentSuccess) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => TransactionSuccessPage(
                          details: ReceiptBuilder().meterPayment(
                              state.momasPaymentResponse.data!.receipt!),
                        )));
          } else if (state is ViewMomasPaymentSuccess) {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => TransactionSuccessPage(
                          failed: state
                                  .momasPaymentResponse.data?.receipt?.status !=
                              PaymentStatus.successful,
                          details: ReceiptBuilder().meterPayment(
                              state.momasPaymentResponse.data!.receipt!),
                        )));
          }
        },
      ),
    );
  }
}
