import 'package:flutter/material.dart';
import 'package:momaspayplus/reuseable/card/mo_option_card.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../../reuseable/pop_button.dart';
import '../../../reuseable/shadow_container.dart';
import 'actions/airtime_screen/airtime_screen.dart';
import 'actions/cable_tv_screen/cable_tv_screen.dart';
import 'actions/data_screen/data_screen.dart';

class BillPaymentOptionsScreen extends StatelessWidget {
  const BillPaymentOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      heading: "Bills Payment",
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: context.isTablet
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15)
                : const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a service below to get started with your payment.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                MoOptionCard(
                    title: 'Airtime',
                    description: 'Buy airtime for all Networks',
                    icon: Icons.phone_android,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const AirtimeScreen()))),
                const SizedBox(height: 10),
                MoOptionCard(
                    title: 'Data Bundle',
                    description: 'Buy data for all Networks',
                    icon: Icons.data_usage,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const DataScreen()))),
                const SizedBox(height: 10),
                MoOptionCard(
                    title: 'Cable',
                    description: 'Subscribe for  your cable',
                    icon: Icons.tv_outlined,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const CableTvScreen()))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
