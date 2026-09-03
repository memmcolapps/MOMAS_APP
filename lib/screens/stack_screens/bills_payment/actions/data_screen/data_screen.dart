import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:momaspayplus/bloc/data_bloc/data_bloc.dart';
import 'package:momaspayplus/bloc/data_bloc/data_event.dart';
import 'package:momaspayplus/bloc/data_bloc/data_state.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_bloc.dart';
import 'package:momaspayplus/domain/data/response/data_response.dart';
import 'package:momaspayplus/domain/repository/bill_repository.dart';
import 'package:momaspayplus/screens/stack_screens/action_detail_skeleton.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/actions/data_screen/plan_dropdown.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/contact_picker.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/form_card.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/reusable/label.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../../../../reuseable/bottom_sheet.dart';
import '../../../../../reuseable/app_error_display.dart';
import '../../../../../reuseable/error_modal.dart';
import '../../../../../reuseable/mo_button.dart';
import '../../../../../reuseable/mo_form.dart';
import '../../../../../reuseable/network_selector.dart';
import '../../../../../reuseable/search_bottom_sheet/ka_dropdown.dart';
import '../../../../../utils/network_enum.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  Network? _selectedNetwork;
  final TextEditingController _phoneController = TextEditingController();
  final FlutterNativeContactPicker _contactPicker =
  FlutterNativeContactPicker();
  Contact? _contact;

  DataResponse? _dataResponse;
  DataBundle? _selectedDataPlan;
  late final DataBloc _dataBloc;

  @override
  void initState() {
    super.initState();
    _dataBloc = DataBloc(repository: BillRepository());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _selectNetwork(Network network) {
    setState(() {
      _selectedNetwork = network;
      _selectedDataPlan = null;
    });
    _dataBloc.add(GetData(network: network));
  }

  List<DataBundle> get _plansForSelectedNetwork {
    if (_selectedNetwork == null || _dataResponse == null) return [];
    return _dataResponse!.data.dataBundle;
  }

  @override
  Widget build(BuildContext context) {
    return ActionDetailSkeleton(
      heading: 'Data Bundle',
      body: BlocProvider.value(
        value: _dataBloc,
        child: BlocListener<DataBloc, DataState>(
          listener: (context, state) {
            switch (state) {
              case DataFailure():
                AppErrorDisplay.show(context, state.error);
              case DataSuccess():
                setState(() => _dataResponse = state.response);
              case BuyDataSuccess():
                showSuccessBottomSheet(context, state.response.message ?? '');
              default:
            }
          },
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

                // ── Network ─────────────────────────────────────────
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

                // ── Plan selector ────────────────────────────────────
                FormCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Label(text: 'Select Plan'),
                      const SizedBox(height: 10),
                      BlocBuilder<DataBloc, DataState>(
                          builder: (context, state) {
                          return PlanDropdown(
                            selectedNetwork: _selectedNetwork,
                            plans: _plansForSelectedNetwork,
                            selectedPlan: _selectedDataPlan,
                            isLoading: state is DataPlansLoading,
                            onChanged: (plan) =>
                                setState(() => _selectedDataPlan = plan),
                          );
                        }
                      ),

                      // Amount display — only when a plan is selected
                      if (_selectedDataPlan != null) ...[
                        const SizedBox(height: 12),
                        MoFormWidget(
                          enable: false,
                          controller: TextEditingController(
                            text: '₦${_selectedDataPlan!.price}',
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
                const SizedBox(height: 12),

                // ── Phone ────────────────────────────────────────────
                FormCard(
                  child: Row(
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
                          title: 'Phone Number',
                        ),
                      ),
                      const SizedBox(width: 10),
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
                ),
                const SizedBox(height: 28),

                // ── CTA ──────────────────────────────────────────────
                BlocBuilder<DataBloc, DataState>(
                  builder: (context, state) {
                    return MoButton(
                      isLoading: state is DataLoading,
                      title: 'BUY NOW',
                      onTap: () {
                        if (_selectedNetwork == null) {
                          showErrorBottomSheet(
                              context, 'Please select a network');
                          return;
                        }
                        if (_selectedDataPlan == null) {
                          showErrorBottomSheet(
                              context, 'Please select a data plan');
                          return;
                        }
                        final phone = _phoneController.text.trim();
                        if (phone.isEmpty) {
                          showErrorBottomSheet(
                              context, 'Please enter a phone number');
                          return;
                        }

                        final serviceId =
                        _selectedNetwork!.name.toLowerCase();
                        final amount =
                            _selectedDataPlan!.price ?? '0';
                        final variantCode =
                            _selectedDataPlan!.code ?? '';

                        MoBottomSheet().payment(
                          context,
                          amount: amount,
                          serviceType: ServiceType.data,
                          onPayment: (String ref) {
                            _dataBloc.add(
                              BuyData(
                                serviceId: serviceId,
                                amount: amount,
                                phone: phone,
                                variationCode: variantCode,
                                ref: ref,
                              ),
                            );
                          }, tariffId: '',
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