import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/response/transaction_data_response.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/strings.dart';
import 'package:momaspayplus/utils/time_util.dart';

class TransactionCard extends StatelessWidget {
  final TransactionData data;

  const TransactionCard({super.key, required this.data});

  IconData _serviceIcon(String? serviceType) {
    final type = serviceType?.toLowerCase() ?? '';

    if (type.contains('airtime')) return Icons.phone_android_rounded;
    if (type.contains('data')) return Icons.network_cell_rounded;
    if (type.contains('cable')) return Icons.tv_rounded;
    if (type.contains('token') || type.contains('credit')) return Icons.bolt_rounded;
    if (type.contains('arrear')) return Icons.account_balance_wallet_outlined;

    return Icons.receipt_long_rounded; // fallback
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = [data.serviceType, data.payType]
        .where((e) => e != null && e.isNotEmpty)
        .map((e) => e!.replaceAll('_', ' '))
        .join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: MoColors.mainColor.withOpacity(0.12),
              child: Icon(
                _serviceIcon(data.serviceType),
                color: MoColors.mainColor,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NGN ${data.amount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  TimeUtil.formatMMMMDY(data.createdAt ?? ""),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.status!.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.status.toString().toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 9,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}