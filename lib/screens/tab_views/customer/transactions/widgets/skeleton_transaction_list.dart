
import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/transactions/widgets/skeleton_transaction_card.dart';

class SkeletonTransactionList extends StatelessWidget {
  const SkeletonTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 16),
      itemBuilder: (_, __) => const SkeletonTransactionCard(),
    );
  }
}