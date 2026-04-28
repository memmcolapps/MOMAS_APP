import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/domain/data/response/feature.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/domain/repository/dashboard_repository.dart';
import 'package:momaspayplus/domain/service/dashboard_service.dart';
import 'package:momaspayplus/screens/generate_token/access_token_verification.dart';
import 'package:momaspayplus/screens/tab_views/customer/profile/profile_screen.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/home_page.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/analytics.dart';
import 'package:momaspayplus/screens/tab_views/customer/transactions/transactions.dart';
import 'package:momaspayplus/utils/images.dart';
import 'nav_item.dart';

class NavConfig {
  static List<NavItem> getTabsForRole(UserRole? role, Feature? features) {
    switch (role) {
      case UserRole.estateStaff:
        return [
          const NavItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
            label: 'Home',
            screen: AccessTokenVerification(),
          ),
          const NavItem(
            filledIcon: Icons.settings,
            outlinedIcon: Icons.settings_outlined,
            label: 'Settings',
            screen: ProfileScreen(),
          ),
        ];

      default:
        return [
          const NavItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
            label: 'Home',
            screen: HomePage(),
          ),
          const NavItem(
            filledIcon: Icons.history,
            outlinedIcon: Icons.history_outlined,
            label: 'History',
            screen: Transactions(),
          ),
          if (features?.analysis == 1)
            const NavItem(
              filledIcon: Icons.analytics,
              outlinedIcon: Icons.analytics_outlined,
              label: 'Analytics',
              screen: Analytics(),
            ),
          const NavItem(
            filledIcon: Icons.settings,
            outlinedIcon: Icons.settings_outlined,
            label: 'Settings',
            screen: ProfileScreen(),
          ),
        ];
    }
  }
}
