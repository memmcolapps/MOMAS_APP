import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/domain/repository/dashboard_repository.dart';
import 'package:momaspayplus/domain/service/dashboard_service.dart';
import 'package:momaspayplus/utils/amount_formatter.dart';
import 'package:momaspayplus/utils/shared_pref.dart';

class MainBalance extends StatefulWidget {
  const MainBalance({
    super.key,
  });

  @override
  State<MainBalance> createState() => _MainBalanceState();
}

class _MainBalanceState extends State<MainBalance> {
  bool _isBalanceVisible = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  //TODO: Make this stateless and handle this with provider
  Future<void> _load() async {
    final visible = await SharedPreferenceHelper.getBalanceVisibility();
    setState(() => _isBalanceVisible = visible);
  }

  void _toggleBalanceVisibility() {
    setState(() => _isBalanceVisible = !_isBalanceVisible);
    SharedPreferenceHelper.saveBalanceVisibility(_isBalanceVisible);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletBloc, DashboardState>(
      builder: (context, state) {
        final String? balance = switch (state) {
          WalletSuccessful() => state.wallet.mainWallet.toString(),
          WalletFailure() => "- -",
          _ => null,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Main Wallet",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.wallet_outlined, color: Colors.white),
                const SizedBox(width: 10),

                // Loading → shimmer | Loaded → balance or ***
                balance == null
                    ? const _BalanceShimmer()
                    : Text(
                        balance == "- -"
                            ? "- -"
                            : _isBalanceVisible
                                ? AmountFormatter.formatNaira(
                                    double.tryParse(balance) ?? 0,
                                  )
                                : "***",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                const SizedBox(width: 10),

                if (balance != null && balance != "- -")
                  InkWell(
                    onTap: _toggleBalanceVisibility,
                    child: Icon(
                      _isBalanceVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BalanceShimmer extends StatefulWidget {
  const _BalanceShimmer();

  @override
  State<_BalanceShimmer> createState() => _BalanceShimmerState();
}

class _BalanceShimmerState extends State<_BalanceShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 120,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
