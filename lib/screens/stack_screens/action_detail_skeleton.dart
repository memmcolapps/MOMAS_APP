import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class ActionDetailSkeleton extends StatelessWidget{
  final String heading;
  final Widget body;
  const ActionDetailSkeleton({super.key, required this.heading, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MoColors.mainColor,
        title: Text(
          heading,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700
          ),
        ),
      ),
      body: body,
    );
  }
}