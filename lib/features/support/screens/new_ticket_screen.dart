import 'package:flutter/material.dart';
import 'package:momaspayplus/features/support/widgets/issue_type_bottom_sheet.dart';
import 'package:momaspayplus/features/support/widgets/success_bottom_sheet.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class NewTicketScreen extends StatefulWidget {
  const NewTicketScreen({super.key});

  @override
  State<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends State<NewTicketScreen> {
  String? _selectedIssueType;
  final TextEditingController _messageController = TextEditingController();

  static const List<String> _issueTypes = [
    'Meter Issues',
    'Payment Issues',
    'Other Issues',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _showIssueTypePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => IssueTypeBottomSheet(
        issueTypes: _issueTypes,
        selected: _selectedIssueType,
        onSelected: (type) {
          setState(() => _selectedIssueType = type);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSuccessSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SuccessBottomSheet(
        message:
            'Thank you for contacting MomasPay. \nYour report has been received and our team will review it shortly.',
        onDismiss: () {
          Navigator.of(context).pop(); // close sheet
          Navigator.of(context).pop(); // exit ticket screen
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      heading: 'New Ticket',
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            child: Text(
                'If you are experiencing any issues, please let us know. '
                'We will try to solve them as soon as possible.',
                textAlign: TextAlign.center,
                style: AppTextStyles.ticketText.copyWith(fontSize: 14)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: MoColors.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE4E7EC), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Issue Type label
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Issue Type',
                        style: AppTextStyles.ticketHeading.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      const TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Issue Type selector
                GestureDetector(
                  onTap: _showIssueTypePicker,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFE4E7EC),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedIssueType ?? 'Select Issue Type',
                          style: AppTextStyles.ticketText.copyWith(
                            color: _selectedIssueType != null
                                ? Colors.black
                                : MoColors.ticketInfo,
                            fontSize: 14,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF98A2B3),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Message label
                Text(
                  'Message',
                  style: AppTextStyles.ticketHeading.copyWith(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // Message field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE4E7EC),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _messageController,
                    maxLines: 5,
                    minLines: 5,
                    style: AppTextStyles.ticketText.copyWith(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      hintStyle: AppTextStyles.ticketInfo.copyWith(
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          MoButton(
            title: "Send",
            onTap: _showSuccessSheet,
          )
        ],
      ),
    );
  }
}
