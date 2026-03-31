import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/disconnection_banner.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/dashboard_builder.dart';

import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:shimmer/shimmer.dart';

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserBloc>().state;
    final dashboardState = context.watch<DashboardBloc>().state;

    // TODO(DON): Work on the flow .. can be better
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 45),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("What will you like to do?"),
              userState is GetUserSuccessful && userState.user.meter?.status != 1
                  ? const MeterDisconnectedBanner()
                  : const SizedBox.shrink(),
              GridView.count(
                crossAxisCount: 3,
                childAspectRatio: .8,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 12.0, bottom: 100),
                children: dashboardState is FeaturesSuccessful &&
                        userState is GetUserSuccessful
                    ? DashboardBuilder.builder(
                            dashboardState.feature, context, userState.user)
                        .map((value) => _GridItem(
                              image: value.image,
                              title: value.title,
                              subtitle: value.subtitle,
                              onTap: value.onTap,
                              active: value.active,
                            ))
                        .toList()
                    : _buildShimmerItems(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildShimmerItems() {
    return List.generate(9, (index) => _buildShimmerItem());
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin: const EdgeInsets.all(8.0),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool active;

  const _GridItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: active ? onTap : null,
      borderRadius: BorderRadius.circular(15.0),
      child: Container(
        decoration: BoxDecoration(
            color: active ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(15.0),
            border:
                active ? null : Border.all(color: Colors.grey[300]!, width: 1),
            boxShadow:
                // active
                //     ?
                const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(4, 4),
                blurRadius: 15,
              ),
            ]
            // : null,
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context.isTablet ? 80 : 35,
              width: context.isTablet ? 80 : 35,
              child: ColorFiltered(
                colorFilter: active
                    ? const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      )
                    : const ColorFilter.matrix(<double>[
                        0.2126, 0.7152, 0.0722, 0, 0, // R
                        0.2126, 0.7152, 0.0722, 0, 0, // G
                        0.2126, 0.7152, 0.0722, 0, 0, // B
                        0, 0, 0, 1, 0, // A
                      ]),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.isTablet ? 14.0 : 8,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.isTablet ? 13.0 : 7,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
