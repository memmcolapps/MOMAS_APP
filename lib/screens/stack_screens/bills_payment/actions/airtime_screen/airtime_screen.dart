import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_bloc.dart';
import 'package:momaspayplus/domain/repository/bill_repository.dart';
import 'package:momaspayplus/screens/stack_screens/action_detail_skeleton.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/contact_picker.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/form_card.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/label.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../../../../bloc/airtime_bloc/airtime_bloc.dart';
import '../../../../../bloc/airtime_bloc/airtime_event.dart';
import '../../../../../bloc/airtime_bloc/airtime_state.dart';
import '../../../../../reuseable/bottom_sheet.dart';
import '../../../../../reuseable/app_error_display.dart';
import '../../../../../reuseable/error_modal.dart';
import '../../../../../reuseable/mo_button.dart';
import '../../../../../reuseable/mo_form.dart';
import '../../../../../reuseable/network_selector.dart';
import '../../../../../utils/network_enum.dart';

class AirtimeScreen extends StatefulWidget {
  const AirtimeScreen({super.key});

  @override
  State<AirtimeScreen> createState() => _AirtimeScreenState();
}

class _AirtimeScreenState extends State<AirtimeScreen> {
  Network? _selectedNetwork;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FlutterNativeContactPicker _contactPicker =
  FlutterNativeContactPicker();
  Contact? _contact;

  final List<int> _quickAmounts = [100, 200, 500, 1000, 2000];

  void _selectNetwork(Network network) =>
      setState(() => _selectedNetwork = network);

  void _selectQuickAmount(int amount) =>
      setState(() => _amountController.text = amount.toString());

  @override
  Widget build(BuildContext context) {
    return ActionDetailSkeleton(
      heading: 'Buy Airtime',
      body: BlocProvider(
        create: (context) => AirtimeBloc(repository: BillRepository()),
        child: SingleChildScrollView(
          padding: context.isTablet
              ? EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15,
            vertical: 20,
          )
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Network ───────────────────────────────────────────
              FormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Label(text: 'Select Network'),
                    const SizedBox(height: 14),
                    NetworkSelector(
                      selectedNetwork: _selectedNetwork,
                      onSelectNetwork: _selectNetwork,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Phone + Amount ────────────────────────────────────
              FormCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phone row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: MoFormWidget(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(
                              Icons.phone_outlined,
                              color: MoColors.textHint,
                              size: 20,
                            ),
                            title: "Phone Number",
                          ),
                        ),

                        ContactPickerButton(
                          onTap: () async {
                            final contact =
                            await _contactPicker.selectContact();
                            if (contact != null) {
                              setState(() {
                                _contact = contact;
                                _phoneController.text =
                                    contact.phoneNumbers?.first ?? '';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Amount
                    MoFormWidget(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: MoColors.textHint,
                        size: 20,
                      ),
                      title: "Amount (₦)",
                    ),
                    const SizedBox(height: 14),

                    // Quick chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _quickAmounts.map((amount) {
                        final selected =
                            _amountController.text == amount.toString();
                        return GestureDetector(
                          onTap: () => _selectQuickAmount(amount),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: selected
                                  ? MoColors.mainColor
                                  : MoColors.mainColorLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: selected
                                    ? MoColors.mainColor
                                    : MoColors.mainColorMid,
                              ),
                            ),
                            child: Text(
                              '₦$amount',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : MoColors.mainColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── CTA ───────────────────────────────────────────────
              BlocConsumer<AirtimeBloc, AirtimeState>(
                builder: (context, state) {
                  return MoButton(
                    isLoading: state is AirtimeLoading,
                    title: "BUY NOW",
                    onTap: () {
                      if (_selectedNetwork == null) {
                        showErrorBottomSheet(
                            context, "Please select a network");
                        return;
                      }
                      final serviceId =
                      _selectedNetwork!.name.toLowerCase();
                      final amount = _amountController.text.trim();
                      final phone = _phoneController.text.trim();

                      if (amount.isEmpty) {
                        showErrorBottomSheet(
                            context, "Please enter an amount");
                        return;
                      }
                      if (phone.isEmpty) {
                        showErrorBottomSheet(
                            context, "Please enter a phone number");
                        return;
                      }

                      MoBottomSheet().payment(
                        context,
                        amount: amount,
                        serviceType: ServiceType.airtime,
                        onPayment: (String ref) {
                          BlocProvider.of<AirtimeBloc>(context).add(
                            BuyAirtime(
                              ref: ref,
                              serviceId: serviceId,
                              amount: amount,
                              phone: phone,
                            ),
                          );
                        }, tariffId: '',
                      );
                    },
                  );
                },
                listener: (context, state) {
                  switch (state) {
                    case AirtimeFailure():
                      AppErrorDisplay.show(context, state.error);
                    case AirtimeSuccess():
                      showSuccessBottomSheet(
                          context, state.response.message ?? "");
                    default:
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}