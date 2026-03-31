import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/bloc/momas_bloc/momas_bloc.dart';
import 'package:momaspayplus/screens/stack_screens/service/service_screen.dart';
import 'package:momaspayplus/screens/stack_screens/momos_payment/momas_payment_screen.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:momaspayplus/utils/images.dart';

class QuickWidgets extends StatelessWidget {
  const QuickWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final meterStatus = context.select((UserBloc bloc) {
      final state = bloc.state;
      return state is GetUserSuccessful ? state.user.meter?.status : null;
    });

    final bool meterActive = meterStatus == 2 ? true : false;

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(4, 4),
              blurRadius: 15),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          quickWidget(
              context: context,
              title: "Buy Units",
              image: MoImage.momasPayment,
              active: meterActive,
              onTap: meterActive
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const MomasPaymentScreen(
                                    momasPaymentType: MomasPaymentType.self,
                                  )));
                    }
                  : () {}),
          // quickWidget(
          //     title: "Fund Wallet",
          //     image: MoImage.topUpWallet),
          quickWidget(
              context: context,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const ServiceScreen()));
              },
              title: "Services",
              image: MoImage.services),
        ],
      ),
    );
  }

  Widget quickWidget(
      {required String image,
      bool active = true,
      String? title,
      VoidCallback? onTap,
      required BuildContext context}) {
    return InkWell(
      onTap: active ? onTap : () {},
      child: Container(
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(15.0),
          border:
              active ? null : Border.all(color: Colors.grey[300]!, width: 1),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(4, 4),
                blurRadius: 15),
          ],
        ),
        child: ColorFiltered(
          colorFilter: active
              ? const ColorFilter.mode(
                  Colors.transparent,
                  BlendMode.multiply,
                )
              : const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0, // R
                  0.2126, 0.7152, 0.0722, 0, 0, // G
                  0.2126, 0.7152, 0.0722, 0, 0, // B
                  0, 0, 0, 1, 0, // A
                ]),
          child: Padding(
            padding: context.isTablet
                ? const EdgeInsets.symmetric(horizontal: 20)
                : const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                    width: context.isTablet ? 40 : 25,
                    height: context.isTablet ? 40 : 25,
                    child: Image.asset(image)),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  title ?? "",
                  style: TextStyle(fontSize: context.isTablet ? 15 : 8),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
