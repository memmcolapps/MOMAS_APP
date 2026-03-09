import 'package:flutter/material.dart';

class TabViewSkeleton extends StatelessWidget {
  const TabViewSkeleton(
      {required this.appBarTitle, required this.body, super.key});

  final String appBarTitle;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: Text(
          appBarTitle,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: body,
    );
  }
}
