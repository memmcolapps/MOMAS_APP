import 'package:flutter/material.dart';
import 'package:momaspayplus/core/widgets/mo_bottom_sheet.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class IssueTypeBottomSheet extends StatelessWidget {
  const IssueTypeBottomSheet({
    super.key,
    required this.issueTypes,
    required this.onSelected,
    this.selected,
  });

  final List<String> issueTypes;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return MoBottomSheet(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: issueTypes.length,
        separatorBuilder: (_, __) => const Divider(
          height: 1,
          indent: 16,
          endIndent: 16,
          color: Color(0xFFF2F4F7),
        ),
        itemBuilder: (context, index) {
          final type = issueTypes[index];
          final isSelected = type == selected;
          return InkWell(
            onTap: () => onSelected(type),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    type,
                    style: AppTextStyles.ticketText.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_rounded, size: 18, color: Colors.black),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}