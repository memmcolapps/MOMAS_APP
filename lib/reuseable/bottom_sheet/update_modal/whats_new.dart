import 'package:momaspayplus/bloc/app_version_bloc/update_state.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/app_info.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/modal_content_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/images.dart';

class WhatsNew extends StatefulWidget {
  final String updateDate;
  // final List<String> whatsNewContent;
  final String whatsNewContent;

  const WhatsNew({
    required this.updateDate,
    required this.whatsNewContent,
    super.key,
  });

  @override
  State<WhatsNew> createState() => _WhatsNewState();
}

class _WhatsNewState extends State<WhatsNew> {
  bool _showWhatsNew = false;

  void _toggleWhatsNew() {
    setState(() {
      _showWhatsNew = !_showWhatsNew;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggleWhatsNew,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What's new",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Updated on ${widget.updateDate}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5F6368),
                      ),
                    ),
                  ],
                ),
                AnimatedRotation(
                  turns: _showWhatsNew ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF5F6368),
                  ),
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            crossFadeState: _showWhatsNew
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
            firstChild: const SizedBox.shrink(),
            secondChild: Text(
              widget.whatsNewContent,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF5F6368),
              ),
            ),

            // Container(
            //   margin: const EdgeInsets.only(top: 16, left: 16),
            //   padding: const EdgeInsets.only(left: 12),
            //   decoration: const BoxDecoration(
            //     border: Border(
            //       left: BorderSide(
            //         color: Color(0xFFE0E0E0),
            //         width: 2,
            //       ),
            //     ),
            //   ),
            //   child:
            //
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: widget.whatsNewContent
            //         .map((item) => Padding(
            //               padding: const EdgeInsets.only(bottom: 8.0),
            //               child: Row(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   const Text(
            //                     '• ',
            //                     style: TextStyle(
            //                       color: Color(0xFF34A853),
            //                       fontSize: 14,
            //                     ),
            //                   ),
            //                   Expanded(
            //                     child: Text(
            //                       item,
            //                       style: const TextStyle(
            //                         fontSize: 14,
            //                         color: Color(0xFF5F6368),
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ))
            //         .toList(),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
