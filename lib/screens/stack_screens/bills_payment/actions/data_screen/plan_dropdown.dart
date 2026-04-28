// plan_dropdown.dart

import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/response/data_response.dart';
import 'package:momaspayplus/reuseable/search_bottom_sheet/ka_dropdown.dart';
import 'package:momaspayplus/screens/stack_screens/bills_payment/actions/data_screen/dropdown_placeholder.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/network_enum.dart';

class PlanDropdown extends StatelessWidget {
  final Network? selectedNetwork;
  final List<DataBundle> plans;
  final DataBundle? selectedPlan;
  final bool isLoading;
  final ValueChanged<DataBundle?> onChanged;

  const PlanDropdown({
    super.key,
    required this.selectedNetwork,
    required this.plans,
    required this.selectedPlan,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Loading
    if (isLoading) {
      return const DropdownPlaceholder(
        icon: Icons.downloading_outlined,
        message: 'Fetching available plans...',
        isLoading: true,
      );
    }

    // 2. No network selected
    if (selectedNetwork == null) {
      return const DropdownPlaceholder(
        icon: Icons.cell_tower_outlined,
        message: 'Select a network above to see available plans',
      );
    }

    // 3. No plans returned
    if (plans.isEmpty) {
      return DropdownPlaceholder(
        icon: Icons.wifi_off_outlined,
        message:
        'No plans available for ${selectedNetwork!.displayName}. Try selecting the network again.',
      );
    }

    // 4. Plans available — neutralize EPDropdownButton's built-in quirks
    return _NeutralizedDropdown(
      plans: plans,
      selectedPlan: selectedPlan,
      onChanged: onChanged,
    );
  }
}

// ── Wrapper that cancels EPDropdownButton's built-in padding and title ─────

class _NeutralizedDropdown extends StatelessWidget {
  final List<DataBundle> plans;
  final DataBundle? selectedPlan;
  final ValueChanged<DataBundle?> onChanged;

  const _NeutralizedDropdown({
    required this.plans,
    required this.selectedPlan,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: EPDropdownButton<DataBundle>(
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
        underline: const SizedBox.shrink(), // no underline divider
        iconEnabledColor: MoColors.mainColor,
        iconDisabledColor: MoColors.textHint,
        searchMatcher: (item, text) =>
            item.description.toLowerCase().contains(text.toLowerCase()),
        onChanged: onChanged,
        items: plans
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e.description,
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