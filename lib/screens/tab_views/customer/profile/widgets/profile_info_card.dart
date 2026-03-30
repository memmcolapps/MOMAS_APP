import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';
import '../../../../../domain/data/response/user_model.dart';

class ProfileInfoCard extends StatefulWidget {
  const ProfileInfoCard({super.key});

  @override
  State<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends State<ProfileInfoCard> {
  @override
  void initState() {
    super.initState();
    log("fetching user >>>>");
    context.read<UserBloc>().add(GetUserDashboardEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, DashboardState>(
      builder: (context, userState) {
        if (userState is FeaturesLoading) {
          return const _ProfileShimmer();
        }

        final User? user = switch (userState) {
          GetUserSuccessful() => userState.user,
          _ => null,
        };

        return _ProfileCard(user: user);
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final User? user;
  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isDisConnected = user != null && user?.meterStatus != 2;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Status tag — top right corner
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDisConnected
                          ? const Color(0xFFFF5252)
                          : Colors.green,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isDisConnected ? "Disconnected" : "Connected",
                    style: TextStyle(
                      color: isDisConnected
                          ? const Color(0xFFFF5252)
                          : Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage(MoImage.profilePic),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            () {
                              final name =
                                  "${user?.firstName ?? ""} ${user?.lastName ?? ""}"
                                      .trim();
                              return name.isEmpty ? "—" : name;
                            }(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user?.email ?? "—",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(
                  color: Colors.white.withValues(alpha: 0.15),
                  height: 1,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _InfoChip(
                      icon: Icons.location_city_outlined,
                      label: user?.estateName ?? "—",
                    ),
                    const SizedBox(width: 10),
                    _InfoChip(
                      icon: isDisConnected
                          ? Icons.power_off_outlined
                          : Icons.electric_meter_outlined,
                      label: user?.meterNo ?? "—",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileShimmer extends StatefulWidget {
  const _ProfileShimmer();

  @override
  State<_ProfileShimmer> createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<_ProfileShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
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
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ShimmerBox(
                width: 78,
                height: 78,
                borderRadius: 39,
                animation: _animation,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBox(
                      width: 140,
                      height: 18,
                      borderRadius: 6,
                      animation: _animation,
                    ),
                    const SizedBox(height: 8),
                    _ShimmerBox(
                      width: 180,
                      height: 13,
                      borderRadius: 6,
                      animation: _animation,
                    ),
                  ],
                ),
              ),
              _ShimmerBox(
                width: 72,
                height: 28,
                borderRadius: 20,
                animation: _animation,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(
              color: Colors.white.withValues(alpha: 0.2),
              height: 1,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 36,
                  borderRadius: 12,
                  animation: _animation,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ShimmerBox(
                  width: double.infinity,
                  height: 36,
                  borderRadius: 12,
                  animation: _animation,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Animation<double> animation;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(animation.value - 1, 0),
                end: Alignment(animation.value, 0),
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.22),
                  Colors.white.withValues(alpha: 0.08),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
