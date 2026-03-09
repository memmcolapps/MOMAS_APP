import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/domain/repository/dashboard_repository.dart';
import 'package:momaspayplus/domain/service/dashboard_service.dart';
import 'package:momaspayplus/screens/generate_token/access_token_verification.dart';
import 'package:momaspayplus/screens/profile/profile_screen.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/home_page.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/analytics.dart';
import 'package:momaspayplus/screens/tab_views/customer/transactions/transactions.dart';
import 'package:momaspayplus/utils/images.dart';
import 'nav_item.dart';

class NavConfig {
  static List<NavItem> getTabsForRole(UserRole? role) {
    switch (role) {
      case UserRole.estateStaff:
        return [
          const NavItem(
              filledIcon: Icons.home,
              outlinedIcon: Icons.home_outlined,
              label: 'Home',
              screen: AccessTokenVerification()
          ),
          const NavItem(
              filledIcon: Icons.settings,
              outlinedIcon: Icons.settings_outlined,
              label: 'Settings',
              screen: ProfileScreen()
          ),
        ];

      // case UserRole.admin:
      //   return [
      //     NavItem(imageUrl: MoImage.home, label: 'Home'),
      //     NavItem(imageUrl: MoImage.history, label: 'History'),
      //     NavItem(imageUrl: MoImage.analyticsTab, label: 'Analytics'),
      //     NavItem(imageUrl: MoImage.settingsIcon, label: 'Settings'),
      //   ];

      // case UserRole.customer:
      //   return [
      //     NavItem(imageUrl: MoImage.home, label: 'Home'),
      //     NavItem(imageUrl: MoImage.analyticsTab, label: 'Analytics'),
      //   ];

      default:
        return [
          NavItem(
              filledIcon: Icons.home,
              outlinedIcon: Icons.home_outlined,
              label: 'Home',
              screen: MultiBlocProvider (
                  providers: [
                    BlocProvider<WalletBloc>(
                      create: (BuildContext context) =>
                      WalletBloc(DashboardService(DashboardRepository()))
                        ..add(WalletDashboardEvent()),
                    ),
                    BlocProvider<PromoBloc>(
                      create: (BuildContext context) =>
                      PromoBloc(DashboardService(DashboardRepository()))
                        ..add(PromotionEvent()),
                    ),
                    BlocProvider<DashboardBloc>(
                      create: (BuildContext context) =>
                      DashboardBloc(DashboardService(DashboardRepository()))
                        ..add(FeatureDashboardEvent()),
                    ),
                  ],
                  child: const HomePage()
              )
          ),
          const NavItem(
              filledIcon: Icons.history,
              outlinedIcon: Icons.history_outlined,
              label: 'History',
              screen: Transactions()
          ),
          // const NavItem(
          //     filledIcon: Icons.analytics,
          //     outlinedIcon: Icons.analytics_outlined,
          //     label: 'Analytics',
          //     screen: Analytics()
          // ),
          const NavItem(
              filledIcon: Icons.settings,
              outlinedIcon: Icons.settings_outlined,
              label: 'Settings',
              screen: ProfileScreen()
          ),
        ];
    }
  }
}
