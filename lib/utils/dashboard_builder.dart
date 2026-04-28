import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/momas_bloc/momas_bloc.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_bloc.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_event.dart';
import 'package:momaspayplus/screens/stack_screens/service/service_screen.dart';

import '../domain/data/response/feature.dart';
import '../domain/data/response/user_model.dart';
import 'package:momaspayplus/screens/stack_screens/arrears/arrears_page.dart';
import '../screens/stack_screens/bills_payment/bill_selected_screen.dart';
import '../screens/stack_screens/access_token/access_token_screen.dart';
import '../screens/generate_token/access_token_verification.dart';
import '../screens/metrics/metrics_screen.dart';
import '../screens/stack_screens/momos_payment/momas_payment_screen.dart';
import '../screens/reprint_token/reprint_token_screen.dart';
import '../screens/stack_screens/support/support_screen.dart';
import 'images.dart';

class DashboardBuilder {
  static List<GridItemModel> builder(
      Feature future, BuildContext context, User? user) {

    // TODO(DON): Come back and fix this code
    log("features: ${future}");
    List<GridItemModel> value = [];
    if (future.momasMeter != 0) {
      value.add(
        GridItemModel(
            image: MoImage.momasPayment,
            title: "Buy Units",
            subtitle: "Buy more unit for your momas meter",
            active: future.momasMeter == 2 ? false : true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const MomasPaymentScreen(
                            momasPaymentType: MomasPaymentType.self,
                          )));
            }),
      );
    }
    if (future.otherMeter != 0) {
      value.add(
        GridItemModel(
            image: MoImage.meterPayment,
            title: "Pay Other Meter",
            subtitle: "Buy  unit for other meters",
            active: future.otherMeter == 2 ? false : true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const MomasPaymentScreen(
                            momasPaymentType: MomasPaymentType.others,
                          )));
            }),
      );
    }
    if (future.printToken != 0) {
      value.add(
        GridItemModel(
            image: MoImage.reprintToken,
            title: "Reprint Token",
            subtitle: "Reprint your purchased token",
            active: future.printToken == 2 ? false : true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ReprintTokenScreen()));
            }),
      );
    }
    if (future.accessToken != 0) {
      value.add(
        GridItemModel(
            image: MoImage.accessToken,
            title: "Access Token",
            subtitle: user?.userRole == UserRole.estateStaff
                ? "Verify estate token"
                : "Generate and manage security token",
            active: future.accessToken == 2 ? false : true,
            onTap: () {
              print(user?.userRole);
              if ((user?.userRole == UserRole.estateStaff)) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AccessTokenVerification()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const AccessTokenScreen()));
              }
            }),
      );
    }
    if (future.services != 0) {
      value.add(
        GridItemModel(
            image: MoImage.services,
            title: "Services",
            subtitle: "Request for any services in your estate",
            active: future.services == 2 ? false : true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const ServiceScreen()));
            }),
      );
    }
    if (future.billPayment != 0) {
      value.add(
        GridItemModel(
            image: MoImage.billPayment,
            title: "Bill Payment",
            subtitle: "Manage and add beneficiary to your account",
            active: future.billPayment == 2 ? false : true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const BillPaymentOptionsScreen()));
            }),
      );
    }
    if (future.support != 0) {
      value.add(
        GridItemModel(
            image: MoImage.support,
            title: "Support",
            subtitle: "Contact our 24/7 support",
            active: future.support == 2 ? false : true,
            onTap: () {
              final settingBloc = context.read<SettingsBloc>();
              settingBloc.add(SupportSettingEvent());

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: settingBloc,
                        child: const SupportScreen(),
                      )));
            }),
      );
    }
    // if (future.topUp == 1) {
    //   value.add(
    //     GridItemModel(
    //         image: MoImage.topUpWallet,
    //         title: "Top up wallet",
    //         subtitle: "Fund your wallet easily",
    //         onTap: null),
    //   );
    // }
    if (future.analysis != 0) {
      value.add(
        GridItemModel(
            image: MoImage.analytics,
            title: "Analytics",
            subtitle: "Buy Airtime and Data for all Network",
            active: future.analysis == 2 ? false : true,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => const MetricsScreen()));
            }),
      );
    }

    value.add(
      GridItemModel(
          image: MoImage.analytics,
          title: "Arrears",
          subtitle: "Buy for unpaid utilities",
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const CustomerArrearsPage()));
          }),
    );
    return value;
  }
}

class GridItemModel {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool active;

  GridItemModel({
    required this.image,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.active = true
  });
}
