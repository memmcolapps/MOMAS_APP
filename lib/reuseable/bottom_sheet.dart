import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_bloc.dart';
import 'package:momaspayplus/reuseable/search_bottom_sheet/payment_bottom_sheet.dart';
import 'package:momaspayplus/utils/check_admin_charge_checker.dart';

import '../domain/data/response/is_admin_fees_paid.dart';
import '../domain/repository/payment_repository.dart';
import '../utils/colors.dart';

class MoBottomSheet {
  Future payment(BuildContext context,
      {required String amount,
        required ServiceType serviceType,
        Function(String ref)? onPayment,
        bool? showMonthlyFee = true}) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _BottomSheetContent(
          amount: amount,
          serviceType: serviceType,
          onPayment: onPayment,
          showMonthlyFee: showMonthlyFee,
        );
      },
    );
  }
}

class _BottomSheetContent extends StatefulWidget {
  final String amount;
  final ServiceType serviceType;
  final Function(String ref)? onPayment;
  final bool? showMonthlyFee;

  const _BottomSheetContent({
    required this.amount,
    required this.serviceType,
    this.onPayment,
    this.showMonthlyFee,
  });

  @override
  State<_BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<_BottomSheetContent> {
  late Future<IsAdminPaidModel?> _adminFeeFuture;

  @override
  void initState() {
    super.initState();
    _adminFeeFuture = PaymentRepository().checkAminFeeIsPayed();
  }

  /// Call this after returning from the arrears page to re-check the fee
  void _recheckAdminFee() {
    setState(() {
      _adminFeeFuture = PaymentRepository().checkAminFeeIsPayed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<IsAdminPaidModel?>(
      future: _adminFeeFuture,
      builder: (BuildContext context, snapshot) {
        // Still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpinKitFadingCircle(color: MoColors.mainColor, size: 50.0),
              SizedBox(height: 20),
              Text(
                "Verifying Fee...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          );
        }

        // Error / bad response
        if (snapshot.hasError || snapshot.data == null || snapshot.data?.status == false) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.black45, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    "Something went wrong. Please try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _recheckAdminFee,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MoColors.mainColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Admin fee not paid — show AdminChargeUI, pass the recheck callback
        if (snapshot.data?.monthlyAdminFee == false &&
            widget.showMonthlyFee == true) {
          return AdminChargeUI(onReturnFromArrears: _recheckAdminFee);
        }

        return SingleChildScrollView(
          child: PaymentBottomSheet(
            amount: widget.amount,
            onPayment: widget.onPayment,
            service: widget.serviceType,
          ),
        );
      },
    );
  }
}