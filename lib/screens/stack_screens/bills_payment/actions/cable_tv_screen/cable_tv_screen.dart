import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:momaspayplus/bloc/cable_tv/cable_tv_bloc.dart';
import 'package:momaspayplus/bloc/cable_tv/cable_event.dart';
import 'package:momaspayplus/bloc/cable_tv/cable_tv_state.dart';
import 'package:momaspayplus/domain/data/response/cable_tv_response.dart';
import 'package:momaspayplus/domain/data/response/cable_tv_verification_response.dart';
import 'package:momaspayplus/domain/repository/bill_repository.dart';
import 'package:momaspayplus/screens/stack_screens/action_detail_skeleton.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/form_card.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/label.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/network_enum.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:momaspayplus/utils/strings.dart';

import '../../../../../bloc/payment_bloc/payment_bloc.dart';
import '../../../../../reuseable/bottom_sheet.dart';
import '../../../../../reuseable/app_error_display.dart';
import '../../../../../reuseable/error_modal.dart';
import '../../../../../reuseable/mo_button.dart';
import '../../../../../reuseable/mo_form.dart';
import '../../../../../reuseable/network_selector.dart';
import '../../../../../reuseable/search_bottom_sheet/ka_dropdown.dart';

class CableTvScreen extends StatefulWidget {
  const CableTvScreen({super.key});

  @override
  State<CableTvScreen> createState() => _CableTvScreenState();
}

class _CableTvScreenState extends State<CableTvScreen> {
  CableEnum? _selectedCable;
  final TextEditingController _decoderController = TextEditingController();

  CableTvResponse? _cableTvResponse;
  CableTvVerificationResponse? _verificationResponse;
  CableData? _selectedPlan;
  String _selectedSubscriptionType = '';
  String _numberOfMonths = '1';

  late final CableTvBloc _cableTvBloc;

  final List<String> _subscriptionTypes = ['renew', 'new'];
  final List<String> _months =
  List.generate(12, (i) => (i + 1).toString());

  @override
  void initState() {
    super.initState();
    _cableTvBloc = CableTvBloc(repository: BillRepository());
      // ..add(const GetCableTv());
  }

  @override
  void dispose() {
    _decoderController.dispose();
    super.dispose();
  }

  void _selectCable(CableEnum cable) {
    setState(() {
      _selectedCable = cable;
      _selectedPlan = null; // reset plan on provider change
      _verificationResponse = null; // reset verification too
    });
  }

  List<CableData> get _plansForSelected {
    if (_selectedCable == null || _cableTvResponse == null) return [];
    return _cableTvResponse!.dataMap[_selectedCable!.name] ?? [];
  }

  bool get _isVerified =>
      isNotEmpty(_verificationResponse?.data?.customerName);

  @override
  Widget build(BuildContext context) {
    return ActionDetailSkeleton(
      heading: 'Cable TV',
      body: BlocProvider.value(
        value: _cableTvBloc,
        child: BlocListener<CableTvBloc, CableTvState>(
          listener: (context, state) {
            switch (state) {
              case CableTvFailure():
                AppErrorDisplay.show(context, state.error);
              case CableTvSuccess():
                setState(() => _cableTvResponse = state.response);
              case CableTvVerificationSuccess():
                setState(() => _verificationResponse = state.response);
              case BuyCableTvSuccess():
                showSuccessBottomSheet(
                    context, state.response.message ?? '');
              default:
            }
          },
          child: SingleChildScrollView(
            padding: context.isTablet
                ? EdgeInsets.symmetric(
              horizontal:
              MediaQuery.of(context).size.width * 0.15,
              vertical: 20,
            )
                : const EdgeInsets.symmetric(
                horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Provider selector ──────────────────────────────
                FormCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Label(text: 'Select Provider'),
                      const SizedBox(height: 14),
                      CableTvSelector(
                        selectedNetwork: _selectedCable,
                        onSelectNetwork: _selectCable,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Decoder + Verify ───────────────────────────────
                FormCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Label(text: 'Decoder Details'),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MoFormWidget(
                              controller: _decoderController,
                              keyboardType: TextInputType.number,
                              prefixIcon: const Icon(
                                Icons.tv_outlined,
                                color: MoColors.textHint,
                                size: 20,
                              ),
                              title: 'Decoder Number',
                            ),
                          ),
                          const SizedBox(width: 10),
                          BlocBuilder<CableTvBloc, CableTvState>(
                            builder: (context, state) {
                              return _VerifyButton(
                                isLoading:
                                state is CableTvVerificationLoading,
                                onTap: () {
                                  if (_selectedCable == null) {
                                    showErrorBottomSheet(context,
                                        'Please select a provider first');
                                    return;
                                  }
                                  if (_decoderController.text
                                      .trim()
                                      .isEmpty) {
                                    showErrorBottomSheet(context,
                                        'Please enter decoder number');
                                    return;
                                  }
                                  _cableTvBloc.add(VerifyDecoderTv(
                                    decoderType: _selectedCable!.name,
                                    decoderNo:
                                    _decoderController.text.trim(),
                                  ));
                                },
                              );
                            },
                          ),
                        ],
                      ),

                      // Verified customer name
                      if (_isVerified) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: MoColors.mainColorLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: MoColors.mainColorMid, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: MoColors.mainColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _verificationResponse
                                      ?.data?.customerName ??
                                      '',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: MoColors.mainColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // ── Plan + Subscription ────────────────────────────
                FormCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Label(text: 'Subscription Details'),
                      const SizedBox(height: 10),

                      // Plan dropdown
                      _CablePlanDropdown(
                        selectedCable: _selectedCable,
                        plans: _plansForSelected,
                        selectedPlan: _selectedPlan,
                        isLoading: false,
                        onChanged: (plan) =>
                            setState(() => _selectedPlan = plan),
                      ),
                      const SizedBox(height: 12),

                      // Subscription type
                      _CableDropdown<String>(
                        hint: 'Subscription Type',
                        value: _selectedSubscriptionType.isEmpty
                            ? null
                            : _selectedSubscriptionType,
                        items: _subscriptionTypes,
                        labelBuilder: (e) => e.toUpperCase(),
                        onChanged: (v) => setState(
                                () => _selectedSubscriptionType = v ?? ''),
                      ),

                      // Number of months — only for 'new'
                      if (_selectedSubscriptionType == 'new') ...[
                        const SizedBox(height: 12),
                        _CableDropdown<String>(
                          hint: 'Number of Months',
                          value: _numberOfMonths,
                          items: _months,
                          labelBuilder: (e) => '$e Month${e == '1' ? '' : 's'}',
                          onChanged: (v) =>
                              setState(() => _numberOfMonths = v ?? '1'),
                        ),
                      ],

                      // Amount — only when plan selected
                      if (_selectedPlan != null) ...[
                        const SizedBox(height: 12),
                        MoFormWidget(
                          enable: false,
                          controller: TextEditingController(
                            text: '₦${_selectedPlan!.variationAmount}',
                          ),
                          keyboardType: TextInputType.number,
                          prefixIcon: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: MoColors.textHint,
                            size: 20,
                          ),
                          title: 'Amount',
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── CTA ────────────────────────────────────────────
                BlocBuilder<CableTvBloc, CableTvState>(
                  builder: (context, state) {
                    return MoButton(
                      isLoading: state is CableTvLoading,
                      title: 'PAY NOW',
                      onTap: () {
                        if (!_isVerified) {
                          showErrorBottomSheet(context,
                              'Please verify your decoder first');
                          return;
                        }
                        if (_selectedPlan == null) {
                          showErrorBottomSheet(
                              context, 'Please select a plan');
                          return;
                        }
                        if (_selectedSubscriptionType.isEmpty) {
                          showErrorBottomSheet(context,
                              'Please select a subscription type');
                          return;
                        }

                        final amount =
                            _selectedPlan!.variationAmount ?? '0';
                        final variantCode =
                            _selectedPlan!.variationCode ?? '';

                        MoBottomSheet().payment(
                          context,
                          serviceType: ServiceType.cable,
                          amount: amount,
                          onPayment: (String ref) {
                            _cableTvBloc.add(
                              BuyCableTv(
                                ref: ref,
                                quantity: _numberOfMonths,
                                subscriptionType:
                                _selectedSubscriptionType == 'renew'
                                    ? 'renew'
                                    : '',
                                decoderType: _selectedCable!.name,
                                decoderNo: _decoderController.text.trim(),
                                amount: amount,
                                variationCode: variantCode,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Verify button ──────────────────────────────────────────────────────────

class _VerifyButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _VerifyButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MoColors.mainColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 50,
          width: 80,
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Text(
            'Verify',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Cable plan dropdown ────────────────────────────────────────────────────

class _CablePlanDropdown extends StatelessWidget {
  final CableEnum? selectedCable;
  final List<CableData> plans;
  final CableData? selectedPlan;
  final bool isLoading;
  final ValueChanged<CableData?> onChanged;

  const _CablePlanDropdown({
    required this.selectedCable,
    required this.plans,
    required this.selectedPlan,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _Placeholder(
        icon: Icons.downloading_outlined,
        message: 'Fetching available plans...',
        isLoading: true,
      );
    }
    if (selectedCable == null) {
      return const _Placeholder(
        icon: Icons.tv_outlined,
        message: 'Select a provider above to see available plans',
      );
    }
    if (plans.isEmpty) {
      return _Placeholder(
        icon: Icons.signal_cellular_off_outlined,
        message:
        'No plans available for ${selectedCable!.name}. Try selecting again.',
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: EPDropdownButton<CableData>(
        itemsListTitle: null,
        iconSize: 20,
        value: selectedPlan,
        hint: const Text(
          'Choose a plan',
          style: TextStyle(
            fontSize: 14,
            color: MoColors.textHint,
            fontWeight: FontWeight.w400,
          ),
        ),
        isExpanded: true,
        underline: const SizedBox.shrink(),
        iconEnabledColor: MoColors.mainColor,
        iconDisabledColor: MoColors.textHint,
        searchMatcher: (item, text) =>
            item.name!.toLowerCase().contains(text.toLowerCase()),
        onChanged: onChanged,
        items: plans
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e.name ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: MoColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

// ── Generic cable dropdown (subscription type, months) ─────────────────────

class _CableDropdown<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const _CableDropdown({
    required this.hint,
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: EPDropdownButton<T>(
        itemsListTitle: null,
        iconSize: 20,
        value: value,
        hint: Text(
          hint,
          style: const TextStyle(
            fontSize: 14,
            color: MoColors.textHint,
            fontWeight: FontWeight.w400,
          ),
        ),
        isExpanded: true,
        underline: const SizedBox.shrink(),
        iconEnabledColor: MoColors.mainColor,
        iconDisabledColor: MoColors.textHint,
        onChanged: onChanged,
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(
              labelBuilder(e),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: MoColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

// ── Placeholder ────────────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isLoading;

  const _Placeholder({
    required this.icon,
    required this.message,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
      const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: MoColors.cardBgAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MoColors.borderIdle, width: 1),
      ),
      child: Row(
        children: [
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                AlwaysStoppedAnimation<Color>(MoColors.mainColor),
              ),
            )
          else
            Icon(icon, size: 16, color: MoColors.textHint),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: MoColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}