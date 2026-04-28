import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/reuseable/views/error_view.dart';
import 'package:momaspayplus/screens/stack_screens/arrears/widgets/arrears_empty.dart';
import 'package:momaspayplus/screens/stack_screens/arrears/widgets/arrears_shimmer.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';

import '../../../bloc/arrears_bloc/arrears_bloc.dart';
import '../../../bloc/payment_bloc/payment_bloc.dart';
import '../../../domain/data/response/arrears_items.dart';
import '../../../domain/repository/bill_repository.dart';
import '../../../reuseable/bottom_sheet.dart';
import '../../../reuseable/error_modal.dart';
import '../../../utils/amount_formatter.dart';
import '../../../utils/colors.dart';

class CustomerArrearsPage extends StatefulWidget {
  const CustomerArrearsPage({super.key});

  @override
  State<CustomerArrearsPage> createState() => _CustomerArrearsPageState();
}

class _CustomerArrearsPageState extends State<CustomerArrearsPage> {
  late CustomerArrearsBloc bloc;
  // Track expand state per item index
  final Set<int> _expandedItems = {};

  @override
  void initState() {
    bloc = CustomerArrearsBloc(repository: BillRepository());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      CustomerArrearsBloc(repository: BillRepository())..add(GetArrears()),
      child: BlocListener<CustomerArrearsBloc, CustomerArrearsState>(
        listener: (context, state) {
          if (state is ArrearPaymentSuccess) {
            showSuccessBottomSheet(context, "Payment of arrears is successful");
            context.read<CustomerArrearsBloc>().add(GetArrears());
          } else if (state is ArrearPaymentFailure) {
            showErrorBottomSheet(context, "Payment failed");
          }
        },
        child: StackScreenSkeleton(
          heading: 'Customer Arrears Summary',
          body: BlocBuilder<CustomerArrearsBloc, CustomerArrearsState>(
            builder: (context, state) {
              // ── Shimmer ──────────────────────────────────────────────────
              if (state is ArrearsLoading || state is ArrearPaymentLoading) {
                return const ArrearsShimmer();
              }

              // ── Error ────────────────────────────────────────────────────
              if (state is ArrearsFailure) {
                return ErrorView(
                  message: state.error,
                  onRetry: () =>
                      context.read<CustomerArrearsBloc>().add(GetArrears()),
                );
              }

              // ── Success ──────────────────────────────────────────────────
              if (state is ArrearsSuccess) {
                final items = state.arrears;

                if (items.isEmpty) {
                  return const ArrearsEmpty();
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isPaid = item.status == 1 || item.status == 2;
                    final hasHistory =
                        item.history != null && item.history!.length > 1;
                    final isExpanded = _expandedItems.contains(index);

                    return _ArrearCard(
                      item: item,
                      isPaid: isPaid,
                      hasHistory: hasHistory,
                      isExpanded: isExpanded,
                      onToggleDetails: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedItems.remove(index);
                          } else {
                            _expandedItems.add(index);
                          }
                        });
                      },
                      onPay: () => payment(
                        context,
                        item.amount.toString(),
                        item.id,
                        true,
                        item.type,
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void payment(BuildContext context, String amount, int arrearsId, bool single,
      serviceType) {
    final ServiceType arrearsType = serviceType.contains("admin")
        ? ServiceType.admin_fee
        : ServiceType.utilities;
    MoBottomSheet().payment(
      context,
      amount: amount,
      showMonthlyFee: false,
      serviceType: serviceType.contains("admin")
          ? ServiceType.admin_fee
          : ServiceType.utilities,
      onPayment: (String ref) {
        debugPrint("<<<<>>>: $ref");
        if (single) {
          context.read<CustomerArrearsBloc>().add(PaySingleArrear(
              id: arrearsId, paymentRef: ref, serviceType: arrearsType));
        } else {
          context.read<CustomerArrearsBloc>().add(PayAllArrears(ref));
        }
      },
    );
  }
}

// ─── Arrear Card ──────────────────────────────────────────────────────────────

class _ArrearCard extends StatelessWidget {
  final ArrearItem item;
  final bool isPaid;
  final bool hasHistory;
  final bool isExpanded;
  final VoidCallback onToggleDetails;
  final VoidCallback onPay;

  const _ArrearCard({
    required this.item,
    required this.isPaid,
    required this.hasHistory,
    required this.isExpanded,
    required this.onToggleDetails,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPaid ? const Color(0xFFE7F9EF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.type.replaceAll("_", " ").toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isPaid
                        ? MoColors.mainColorII
                        : const Color(0xFF0A4DA2),
                  ),
                ),
                Text(
                  AmountFormatter.formatNaira(item.amount),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 12, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  "Start: ${item.createdAt.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                const Spacer(),
                Icon(Icons.event_outlined,
                    size: 12, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  "Due: ${item.nextDueDate.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Pay button ────────────────────────────────────────
            if (!isPaid)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onPay,
                  icon: const Icon(Icons.payment_rounded, size: 16),
                  label: const Text("Pay Now"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding:
                    const EdgeInsets.symmetric(vertical: 13),
                    backgroundColor: MoColors.mainColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

            // ── History toggle ────────────────────────────────────
            if (hasHistory) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onToggleDetails,
                child: Row(
                  children: [
                    Text(
                      isExpanded ? "Hide details" : "See details",
                      style: TextStyle(
                        fontSize: 12,
                        color: MoColors.mainColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: MoColors.mainColor,
                    ),
                  ],
                ),
              ),
            ],

            // ── History list ──────────────────────────────────────
            if (isExpanded && hasHistory) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: item.history!.map((history) {
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AmountFormatter.formatNaira(
                                double.tryParse(history.amount) ?? 0),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13),
                          ),
                          Text(
                            history.createdAt
                                .toLocal()
                                .toString()
                                .split(' ')[0],
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

