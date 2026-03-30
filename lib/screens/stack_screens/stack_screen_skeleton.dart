import 'package:flutter/material.dart';
import 'package:momaspayplus/reuseable/pop_button.dart';
import 'package:momaspayplus/reuseable/shadow_container.dart';

class StackScreenSkeleton extends StatelessWidget {
  final Widget body;
  final String heading;

  const StackScreenSkeleton({
    super.key,
    required this.body,
    required this.heading
  });

  @override
  Widget build(BuildContext context) {
    return Container (
      color: Colors.green,
      child: SafeArea(
          bottom: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(
                    height: 13,
                  ),
                  Center(
                    child: ShadowContainer(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: Row(
                          children: [
                            PopButton().pop(context),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(heading)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: body),
                ],
              ),
            ),
          )
      ),
    );
  }
}