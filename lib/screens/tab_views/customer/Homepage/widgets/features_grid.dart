import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/dashboard_builder.dart';

import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:shimmer/shimmer.dart';

class FeaturesGrid extends StatelessWidget {
  const FeaturesGrid({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(8),
                  color: MoColors.mainColor
                      .withOpacity(0.01)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 5, horizontal: 15),
                child: GridView.count(
                  crossAxisCount: 3,
                  childAspectRatio: .8,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      top: 12.0,
                      bottom: 100),
                  children: state
                  is FeaturesSuccessful
                      ? DashboardBuilder.builder(
                      state.feature,
                      context,
                      user)
                      .map((value) => _GridItem(
                    image: value.image,
                    title: value.title,
                    subtitle:
                    value.subtitle,
                    onTap: value.onTap,
                  ))
                      .toList()
                      : _buildShimmerItems(),
                ),
              ),
            ),
          );
        });
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

  const _GridItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(4, 4),
                blurRadius: 15),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: context.isTablet ? 80 : 35,
              width: context.isTablet ? 80 : 35,
              child: Image.asset(
                image,
                fit: BoxFit.contain,
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
