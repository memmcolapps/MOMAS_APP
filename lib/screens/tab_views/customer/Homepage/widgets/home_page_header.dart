import 'package:flutter/material.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/main_balance.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/promo_section.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/shared_pref.dart';
import 'package:momaspayplus/utils/strings.dart';

class HomePageHeader extends StatelessWidget {

  const HomePageHeader({
    super.key,
    required this.safePadding,
    required this.height,
    // required this.promoDivHeight,
    required this.name,
  });

  final EdgeInsets safePadding;
  final double height;
  // final double promoDivHeight;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: const [0.5, 0.8],
                colors: [
                  MoColors.mainColor,
                  MoColors.mainColorII,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(50)),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                  top: safePadding.top + 12, left: 16, right: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi $name,",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const MainBalance(),
                ],
              ),
            ),
          ),
        ),
        // PromoSection(promoDivHeight: promoDivHeight)
      ],
    );
  }
}
