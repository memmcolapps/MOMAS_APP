import 'package:flutter/material.dart';
import 'package:momaspayplus/bloc/momas_bloc/momas_bloc.dart';
import 'package:momaspayplus/screens/momos_payment/momas_payment_screen.dart';
import 'package:momaspayplus/screens/service/service_screen.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:momaspayplus/utils/images.dart';

class QuickWidgets extends StatelessWidget {
  const QuickWidgets({super.key});

  @override
  Widget build(BuildContext context) {
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => const MomasPaymentScreen(
                              momasPaymentType: MomasPaymentType.self,
                            )));
              }),
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
      String? title,
      VoidCallback? onTap,
      required BuildContext context}) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
    );
  }
}
