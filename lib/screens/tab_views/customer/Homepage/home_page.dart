import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/domain/repository/dashboard_repository.dart';
import 'package:momaspayplus/domain/service/dashboard_service.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/home_page_body.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/home_page_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/quick_widgets.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:momaspayplus/utils/shared_pref.dart';
import 'package:momaspayplus/utils/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PromoBloc promoBloc;
  late WalletBloc walletBloc;
  late DashboardBloc dashboardBloc;

  User? user;
  String name = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  // TODO: Maybe use bloc for this too
  Future<void> _load() async {
    user = await SharedPreferenceHelper.getUser();
    getName(user);
  }

  getName(User? user) {
    var firstname = isEmpty(user?.firstName) ? "" : user?.firstName;
    var lastName = isEmpty(user?.lastName) ? "" : user?.lastName;
    name = "$firstname $lastName";
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safePadding = MediaQuery.paddingOf(context);
    final double headerHeight = safePadding.top + 170;
    final double promoSectionHeight = 145;

    return Scaffold(
        backgroundColor: MoColors.mainColorII,
        body: MultiBlocProvider(
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
          child: CustomScrollView(
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  debugPrint("Refreshing state");
                  context.read<WalletBloc>().add(WalletDashboardEvent());
                  context.read<PromoBloc>().add(PromotionEvent());
                  context.read<DashboardBloc>().add(FeatureDashboardEvent());
                },
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _HomeHeaderDelegate(
                  safePadding: safePadding,
                  headerHeight: headerHeight,
                  name: name,
                ),
              ),


              SliverToBoxAdapter(
                child: HomePageBody(
                  headerHeight: headerHeight,
                  user: user,
                ),
              ),
            ],
          ),
        ));
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final EdgeInsets safePadding;
  final double headerHeight;
  final String name;

  _HomeHeaderDelegate({
    required this.safePadding,
    required this.headerHeight,
    required this.name,
  });

  @override
  double get minExtent => headerHeight;

  @override
  double get maxExtent => headerHeight;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentGeometry.bottomCenter,
      children: [
        HomePageHeader(
          safePadding: safePadding,
          height: headerHeight,
          name: name,
        ),
        Positioned(
          top: headerHeight - 40,
          child: const QuickWidgets(),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_HomeHeaderDelegate old) {
    return old.name != name ||
        old.headerHeight != headerHeight ||
        old.safePadding != safePadding;
  }
}