import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/bloc/momas_bloc/momas_bloc.dart';
import 'package:momaspayplus/screens/stack_screens/service/service_screen.dart';
import 'package:momaspayplus/screens/stack_screens/momos_payment/momas_payment_screen.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:momaspayplus/utils/images.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/bloc/momas_bloc/momas_bloc.dart';
import 'package:momaspayplus/screens/stack_screens/service/service_screen.dart';
import 'package:momaspayplus/screens/stack_screens/momos_payment/momas_payment_screen.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:momaspayplus/utils/images.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/bloc/momas_bloc/momas_bloc.dart';
import 'package:momaspayplus/screens/stack_screens/service/service_screen.dart';
import 'package:momaspayplus/screens/stack_screens/momos_payment/momas_payment_screen.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:momaspayplus/utils/images.dart';

class QuickWidgets extends StatelessWidget {
  const QuickWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final meterStatus = context.select((UserBloc bloc) {
      final state = bloc.state;
      return state is GetUserSuccessful ? state.user.meter?.status : null;
    });

    final bool meterActive = meterStatus == 2;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 80,
      decoration: BoxDecoration(
        color: MoColors.cardBgAlt,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MoColors.borderIdle, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _QuickButton(
            context: context,
            title: "Buy Units",
            image: MoImage.momasPayment,
            active: meterActive,
            onTap: meterActive
                ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MomasPaymentScreen(
                  momasPaymentType: MomasPaymentType.self,
                ),
              ),
            )
                : null,
          ),
          // divider between buttons
          Container(
            width: 1,
            height: 40,
            color: MoColors.borderIdle,
          ),
          _QuickButton(
            context: context,
            title: "Services",
            image: MoImage.services,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServiceScreen()),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String image;
  final String title;
  final bool active;
  final VoidCallback? onTap;
  final BuildContext context;

  const _QuickButton({
    required this.context,
    required this.image,
    required this.title,
    this.active = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: active ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          splashColor: MoColors.mainColor.withOpacity(0.06),
          highlightColor: MoColors.mainColor.withOpacity(0.04),
          child: Padding(
            padding: context.isTablet
                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
                : const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: active ? 1.0 : 0.35,
                  child: SizedBox(
                    width: context.isTablet ? 40 : 26,
                    height: context.isTablet ? 40 : 26,
                    child: Image.asset(image, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.isTablet ? 15 : 12,
                    fontWeight: FontWeight.w600,
                    color: active ? MoColors.textPrimary : MoColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
