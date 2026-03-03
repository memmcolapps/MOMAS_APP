import 'package:flutter/cupertino.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/screens/dashboard/main_dashboard/main_screen.dart';
import 'package:momaspayplus/screens/dashboard/search_screen/search_screen.dart';
import 'package:momaspayplus/screens/generate_token/access_token_verification.dart';
import 'package:momaspayplus/screens/profile/profile_screen.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/home_page.dart';
import 'package:momaspayplus/utils/images.dart';
import 'nav_item.dart';

class NavConfig {
  static List<NavItem> getTabsForRole(UserRole role) {
    switch (role) {
      case UserRole.estateStaff:
        return [
          NavItem(imageUrl: MoImage.home, label: 'Home', screen: const AccessTokenVerification()),
          NavItem(imageUrl: MoImage.settingsIcon, label: 'Settings', screen: const ProfileScreen()),
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
          NavItem(imageUrl: MoImage.home, label: 'Home', screen: const HomePage()),
          NavItem(imageUrl: MoImage.history, label: 'History', screen: const SearchScreen()),
          NavItem(imageUrl: MoImage.analyticsTab, label: 'Analytics', screen: const Placeholder()),
          NavItem(imageUrl: MoImage.settingsIcon, label: 'Settings', screen: const ProfileScreen()),
        ];
    }
  }
}