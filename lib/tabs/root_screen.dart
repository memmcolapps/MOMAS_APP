import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/tabs/nav_destination.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'nav_config.dart';
import 'nav_item.dart';

class RootScreen extends StatefulWidget {
  final UserRole role;
  const RootScreen({super.key, required this.role});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  late List<NavItem> _tabs;

  List<Widget> get _tabScreens => _tabs.map((tab) => tab.screen).toList();
  @override
  void initState() {
    super.initState();
    _tabs = NavConfig.getTabsForRole(widget.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabScreens,
      ),
      backgroundColor: MoColors.whiteColor,
      bottomNavigationBar: NavigationBar(
        elevation: 8,
        shadowColor: MoColors.mainColor.withValues(alpha: 0.75),
        height: 50,
        backgroundColor: Colors.white,
        labelPadding: EdgeInsets.zero,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        indicatorColor: Colors.transparent,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        destinations: _buildDestinations(),
      ),
    );
  }

  List<NavDestination> _buildDestinations() {
    return List.generate(_tabs.length, (index) {
      final tab = _tabs[index];
      return NavDestination(
        isSelected: _selectedIndex == index,
        imageUrl: tab.imageUrl,
      );
    });
  }
}
