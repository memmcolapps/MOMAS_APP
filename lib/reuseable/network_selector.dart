import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';
import '../utils/network_enum.dart';

class NetworkSelector extends StatelessWidget {
  final Network? selectedNetwork;
  final Function(Network) onSelectNetwork;

  final Map<Network, String> networkImages = {
    Network.mtn: MoImage.mtn,
    Network.n9Mobile: MoImage.n9mobile,
    Network.airtel: MoImage.airtel,
    Network.glo: MoImage.glo,
  };

  NetworkSelector({
    super.key,
    this.selectedNetwork,
    required this.onSelectNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: Network.values.map((network) {
        final isSelected = selectedNetwork == network;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onSelectNetwork(network),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? MoColors.mainColorLight
                      : MoColors.cardBgAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? MoColors.mainColor
                        : MoColors.borderIdle,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Uniform circular logo container ──────────────
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: MoColors.cardBgAlt,
                      backgroundImage: AssetImage(networkImages[network]!,),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _networkLabel(network),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: isSelected
                            ? MoColors.mainColor
                            : MoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _networkLabel(Network network) {
    switch (network) {
      case Network.mtn:
        return 'MTN';
      case Network.n9Mobile:
        return '9mobile';
      case Network.airtel:
        return 'Airtel';
      case Network.glo:
        return 'Glo';
    }
  }
}

class CableTvSelector extends StatelessWidget {
  final CableEnum? selectedNetwork;
  final Function(CableEnum) onSelectNetwork;

  final Map<CableEnum, String> networkImages = {
    CableEnum.dstv: MoImage.dstv,
    CableEnum.gotv: MoImage.gotv,
    CableEnum.showmax: MoImage.showMax,
    CableEnum.startimes: MoImage.startimes,
  };

  CableTvSelector({
    super.key,
    this.selectedNetwork,
    required this.onSelectNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: CableEnum.values.map((cable) {
        final isSelected = selectedNetwork == cable;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onSelectNetwork(cable),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? MoColors.mainColorLight
                      : MoColors.cardBgAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? MoColors.mainColor
                        : MoColors.borderIdle,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Uniform circular logo container ──────────────
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(
                        networkImages[cable]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _cableLabel(cable),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        color: isSelected
                            ? MoColors.mainColor
                            : MoColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _cableLabel(CableEnum cable) {
    switch (cable) {
      case CableEnum.dstv:
        return 'DStv';
      case CableEnum.gotv:
        return 'GOtv';
      case CableEnum.showmax:
        return 'Showmax';
      case CableEnum.startimes:
        return 'StarTimes';
    }
  }
}