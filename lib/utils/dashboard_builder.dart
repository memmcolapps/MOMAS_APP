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
  static List<GridItemModel> builder(Feature feature, BuildContext context, User? user) {
    return [
      if (feature.isVisible(feature.momasMeter))
        GridItemModel(
          image: MoImage.momasPayment,
          title: "Buy Units",
          subtitle: "Buy more unit for your momas meter",
          active: feature.isActive(feature.momasMeter),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MomasPaymentScreen(momasPaymentType: MomasPaymentType.self),
          )),
        ),
      if (feature.isVisible(feature.otherMeter))
        GridItemModel(
          image: MoImage.meterPayment,
          title: "Pay Other Meter",
          subtitle: "Buy unit for other meters",
          active: feature.isActive(feature.otherMeter),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MomasPaymentScreen(momasPaymentType: MomasPaymentType.others),
          )),
        ),
      if (feature.isVisible(feature.printToken))
        GridItemModel(
          image: MoImage.reprintToken,
          title: "Reprint Token",
          subtitle: "Reprint your purchased token",
          active: feature.isActive(feature.printToken),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => ReprintTokenScreen(),
          )),
        ),
      if (feature.isVisible(feature.accessToken))
        GridItemModel(
          image: MoImage.accessToken,
          title: "Access Token",
          subtitle: user?.userRole == UserRole.estateStaff
              ? "Verify estate token"
              : "Generate and manage security token",
          active: feature.isActive(feature.accessToken),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => user?.userRole == UserRole.estateStaff
                ? const AccessTokenVerification()
                : const AccessTokenScreen(),
          )),
        ),
      if (feature.isVisible(feature.services))
        GridItemModel(
          image: MoImage.services,
          title: "Services",
          subtitle: "Request for any services in your estate",
          active: feature.isActive(feature.services),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const ServiceScreen(),
          )),
        ),
      if (feature.isVisible(feature.billPayment))
        GridItemModel(
          image: MoImage.billPayment,
          title: "Bill Payment",
          subtitle: "Manage and add beneficiary to your account",
          active: feature.isActive(feature.billPayment),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const BillPaymentOptionsScreen(),
          )),
        ),
      if (feature.isVisible(feature.support))
        GridItemModel(
          image: MoImage.support,
          title: "Support",
          subtitle: "Contact our 24/7 support",
          active: feature.isActive(feature.support),
          onTap: () {
            final settingBloc = context.read<SettingsBloc>()..add(SupportSettingEvent());
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => BlocProvider.value(value: settingBloc, child: const SupportScreen()),
            ));
          },
        ),
      if (feature.isVisible(feature.analysis))
        GridItemModel(
          image: MoImage.analytics,
          title: "Analytics",
          subtitle: "View your usage analytics",
          active: feature.isActive(feature.analysis),
          onTap: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => const MetricsScreen(),
          )),
        ),
      // Arrears is always visible
      GridItemModel(
        image: MoImage.analytics,
        title: "Arrears",
        subtitle: "Buy for unpaid utilities",
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => const CustomerArrearsPage(),
        )),
      ),
    ];
  }

  static GridItemModel? quickSlot2(Feature feature, BuildContext context) {
    return builder(feature, context, null)
        .skip(1)
        .firstOrNull;
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
