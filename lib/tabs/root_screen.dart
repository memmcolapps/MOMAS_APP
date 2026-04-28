import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_bloc.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_state.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
import 'package:momaspayplus/domain/repository/dashboard_repository.dart';
import 'package:momaspayplus/domain/repository/setting_repository.dart';
import 'package:momaspayplus/domain/service/dashboard_service.dart';
import 'package:momaspayplus/tabs/nav_destination.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'nav_config.dart';
import 'nav_item.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  // int _selectedIndex = 0;
  late List<NavItem> _tabs;
  bool _tabsInitialized = false;

  List<Widget> get _tabScreens => _tabs.map((tab) => tab.screen).toList();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_tabsInitialized) {
      final authState = context.read<AuthCubit>().state;
      final user = authState is AuthAuthenticated ? authState.user : null;
      final features = authState is AuthAuthenticated ? authState.features : null;
      _tabs = NavConfig.getTabsForRole(user?.userRole, features);
      _tabsInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = context.watch<TabCubit>().state;

    return MultiBlocProvider(
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
        BlocProvider<UserBloc>(
          create: (BuildContext context) =>
          UserBloc(DashboardService(DashboardRepository()))
            ..add(GetUserDashboardEvent()),
        ),
        BlocProvider<SettingsBloc>(
            create: (BuildContext context) =>
            SettingsBloc(SettingRepository())
        ),
      ],
      child: Scaffold(
        extendBody: true,
        body: _tabScreens[selectedIndex],
        backgroundColor: MoColors.scaffoldWhite,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: MoColors.borderIdle, width: 1),
            ),
          ),
          child: NavigationBar(
            elevation: 0,
            shadowColor: Colors.transparent,
            height: 60,
            backgroundColor: Colors.white,
            labelPadding: EdgeInsets.zero,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              context.read<TabCubit>().changeTab(index);
            },
            indicatorColor: Colors.transparent,
            indicatorShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            destinations: _buildDestinations(selectedIndex),
          ),
        ),
      ),
    );
  }

  List<NavDestination> _buildDestinations(int selectedIndex) {
    return List.generate(_tabs.length, (index) {
      final tab = _tabs[index];
      return NavDestination(
        isSelected: selectedIndex == index,
        filledIcon: tab.filledIcon,
        outlinedIcon: tab.outlinedIcon,
      );
    });
  }
}
