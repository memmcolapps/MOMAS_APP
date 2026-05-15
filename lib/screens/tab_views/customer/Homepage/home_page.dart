import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/features_grid.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/home_page_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/promo_section.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/quick_widgets.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:momaspayplus/core/storage/shared_pref.dart';
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

    return Scaffold(
        backgroundColor: MoColors.mainColorII,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<WalletBloc>().add(WalletDashboardEvent());
            context.read<PromoBloc>().add(PromotionEvent());
            context.read<DashboardBloc>().add(FeatureDashboardEvent());
            context.read<UserBloc>().add(GetUserDashboardEvent());
          },
          child: Column(
            children: [
              // ----- Header Section ------
              Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentGeometry.bottomCenter,
                children: [
                  Column(
                    children: [
                      HomePageHeader(
                        safePadding: safePadding,
                        height: headerHeight,
                        // promoDivHeight: promoDivHeight,
                        name: name,
                      ),
                      Container(
                        height: 55,
                        decoration: const BoxDecoration(
                          color: MoColors.scaffoldWhite,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50)),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: headerHeight - 40,
                    child: const QuickWidgets(),
                  ),
                ],
              ),

              // ----- Body Section ------
              Expanded(
                child: Container(
                  color: MoColors.scaffoldWhite,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PromoSection(),
                      SizedBox(height: 10),
                      FeaturesGrid()
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}
