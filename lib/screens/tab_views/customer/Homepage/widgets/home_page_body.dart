import 'package:flutter/material.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/features_grid.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/promo_section.dart';

class HomePageBody extends StatelessWidget {
  final double headerHeight;
  final User? user;

  const HomePageBody({
    this.user,
    required this.headerHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;

    // TODO: Fix the scrolling of promo section... it should not scroll
    return Container(
      constraints: BoxConstraints(minHeight: screenHeight - headerHeight),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
      ),
      child:  Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          const PromoSection(),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 45,
            ),
            child: Text("What will you like to do?"),
          ),
          FeaturesGrid(user: user)
        ],
      ),
    );
  }
}

