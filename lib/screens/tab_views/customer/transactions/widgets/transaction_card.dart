import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/response/transaction_data_response.dart';
import 'package:momaspayplus/reuseable/shadow_container.dart';
import 'package:momaspayplus/utils/strings.dart';
import 'package:momaspayplus/utils/time_util.dart';

class TransactionCard extends StatelessWidget {
  final TransactionData data;
  final Function(String) retry;

  const TransactionCard({super.key, required this.data, required this.retry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: ShadowContainer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.green[100],
                    child: const Icon(
                      Icons.receipt,
                      color: Colors.green,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NGN${data.amount}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          isNotEmpty(data.note)
                              ? "${data.note}"
                              : "| ${data.serviceType}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11.0,
                          )),
                      Text(
                          isNotEmpty(data.note)
                              ? "${data.note}"
                              : "| ${data.payType}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11.0,
                          )),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      TimeUtil.formatMMMMDY(data.createdAt ?? ""),
                      style: const TextStyle(fontSize: 10),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    data.status == PaymentStatus.successful
                        ? Container(
                      decoration: BoxDecoration(
                          color: data.status!.color,
                          borderRadius: BorderRadius.circular(18)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.status.toString().toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    )
                        : InkWell(
                      onTap: () => showRepeatPaymentDialog(
                          context, data.amount!, () {
                        retry(data.trxId!);
                      }),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.repeat,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showRepeatPaymentDialog(
      BuildContext context, int amount, VoidCallback onRepeat) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Repeat Payment'),
          content: Text('Do you want to repeat the payment of NGN$amount?'),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onRepeat(); // Call the repeat payment action
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}