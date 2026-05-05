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

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "What will you like to do?",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: MoColors.textSecondary,
              ),
            ),
            if (userState is GetUserSuccessful &&
                userState.user.meter?.status != 2)
              const MeterDisconnectedBanner(),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: context.isTablet ? 4 : 3,
              childAspectRatio: context.isTablet ? 1.0 : 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
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
    );
  }

  List<Widget> _buildShimmerItems() {
    return List.generate(9, (index) => _buildShimmerItem());
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: MoColors.borderIdle,
      highlightColor: MoColors.cardBgAlt,
      child: Container(
        decoration: BoxDecoration(
          color: MoColors.cardBg,
          borderRadius: BorderRadius.circular(12),
        ),
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
    return Material(
      color: active ? MoColors.cardBg : MoColors.cardBgAlt,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: active ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        splashColor: MoColors.mainColor.withOpacity(0.06),
        highlightColor: MoColors.mainColor.withOpacity(0.04),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active
                  ? MoColors.borderIdle
                  : MoColors.borderIdle.withOpacity(0.5),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // icon in rounded square — consistent with rest of app
              Container(
                width: context.isTablet ? 56 : 40,
                height: context.isTablet ? 56 : 40,
                decoration: BoxDecoration(
                  color: active
                      ? MoColors.mainColorLight
                      : MoColors.borderIdle.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(8),
                child: Opacity(
                  opacity: active ? 1.0 : 0.35,
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.isTablet ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color: active ? MoColors.textPrimary : MoColors.textHint,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.isTablet ? 12 : 10,
                  color: MoColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}