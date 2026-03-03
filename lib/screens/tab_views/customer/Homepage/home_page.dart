import 'package:flutter/material.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/home_page_body.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/home_page_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/quick_widgets.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    late WalletBloc walletBloc;
    late PromoBloc promoBloc;
    late DashboardBloc dashboardBloc;
    late UserBloc userBloc;

    /// User Bloc
    /// Wallet Bloc
    ///

    final EdgeInsets safePadding = MediaQuery.paddingOf(context);
    return Scaffold(
        backgroundColor: MoColors.mainColorII,
        body: Stack(
          alignment: AlignmentGeometry.bottomCenter,
          children: [
            Column(
              children: [
                HomePageHeader(safePadding: safePadding),
                const HomePageBody()
              ],
            ),
            Positioned(
                top: safePadding.top + 130,
                child: const QuickWidgets()
            )
          ],
        ));
  }
}
