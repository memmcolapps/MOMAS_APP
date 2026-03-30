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
    final bool userActive = user?.meterStatus == 2;

    return Scaffold(
        backgroundColor: MoColors.mainColorII,
        body: Column(
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
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(50)),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: headerHeight - 40,
                  child: QuickWidgets(
                    active: userActive,
                  ),
                ),
              ],
            ),

            // ----- Body Section ------
            Expanded(
                child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PromoSection(),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 45,
                    ),
                    child: Text("What will you like to do?"),
                  ),
                  RefreshIndicator(
                    child: const FeaturesGrid(),
                    onRefresh: () async {
                      debugPrint("Refreshing state");
                      context.read<WalletBloc>().add(WalletDashboardEvent());
                      context.read<PromoBloc>().add(PromotionEvent());
                      context
                          .read<DashboardBloc>()
                          .add(FeatureDashboardEvent());
                    },
                  )
                ],
              ),
            )),
          ],
        )
        // CustomScrollView(
        //   slivers: [
        //     CupertinoSliverRefreshControl(
        //       onRefresh: () async {
        //         debugPrint("Refreshing state");
        //         context.read<WalletBloc>().add(WalletDashboardEvent());
        //         context.read<PromoBloc>().add(PromotionEvent());
        //         context.read<DashboardBloc>().add(FeatureDashboardEvent());
        //       },
        //     ),
        //     SliverPersistentHeader(
        //       pinned: true,
        //       floating: false,
        //       delegate: _HomeHeaderDelegate(
        //         safePadding: safePadding,
        //         headerHeight: headerHeight,
        //         promoDivHeight: promoDivHeight,
        //         name: name,
        //       ),
        //     ),
        //     SliverToBoxAdapter(
        //       child: ConstrainedBox(
        //         constraints: BoxConstraints(
        //           minHeight: MediaQuery.sizeOf(context).height
        //         ),
        //         child: FeaturesGrid(user: user),
        //       ),
        //     ),
        //   ],
        // )
        );
  }
}

// class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
//   final EdgeInsets safePadding;
//   final double headerHeight;
//   final double promoDivHeight;
//   final String name;
//
//   _HomeHeaderDelegate({
//     required this.safePadding,
//     required this.headerHeight,
//     required this.promoDivHeight,
//     required this.name,
//   });
//
//   @override
//   double get minExtent => headerHeight;
//
//   @override
//   double get maxExtent => headerHeight + promoDivHeight;
//
//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Stack(
//       clipBehavior: Clip.none,
//       alignment: AlignmentGeometry.bottomCenter,
//       children: [
//         HomePageHeader(
//           safePadding: safePadding,
//           height: headerHeight,
//           // promoDivHeight: promoDivHeight,
//           name: name,
//         ),
//         Positioned(
//           top: headerHeight - 40,
//           child: const QuickWidgets(),
//         ),
//       ],
//     );
//   }
//
//   @override
//   bool shouldRebuild(_HomeHeaderDelegate old) {
//     return old.name != name ||
//         old.headerHeight != headerHeight + promoDivHeight ||
//         old.safePadding != safePadding;
//   }
// }
