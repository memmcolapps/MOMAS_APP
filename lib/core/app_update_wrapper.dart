import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/core/cubit/app_version_cubit/update_state.dart';
import 'package:momaspayplus/core/cubit/app_version_cubit/update_cubit.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/update_modal.dart';

class AppUpdateWrapper extends StatefulWidget {
  final Widget child;
  const AppUpdateWrapper({
    required this.child,
    super.key
  });

  @override
  State<AppUpdateWrapper> createState() => _AppUpdateWrapperState();
}

class _AppUpdateWrapperState extends State<AppUpdateWrapper> {

  void _showUpdateModal(AppUpdateRequired state) {
    final isMandatory = state.required;

    debugPrint(isMandatory.toString());
    showModalBottomSheet(
      context: context,
      isDismissible: !isMandatory,
      enableDrag: !isMandatory,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PopScope(
        canPop: !isMandatory,
        child: UpdateModal(state: state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUpdateCubit, AppUpdateState>(
        listener: (context, state) {
          if (state is AppUpdateRequired) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) _showUpdateModal(state);
            });
          }
        },
      child: widget.child,
    );
  }
}