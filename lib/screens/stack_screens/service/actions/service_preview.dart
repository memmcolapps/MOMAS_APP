import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/domain/data/response/artisan_list_response.dart';
import 'package:momaspayplus/domain/data/response/service_response.dart';
import 'package:momaspayplus/reuseable/rating_star.dart';
import 'package:momaspayplus/screens/stack_screens/action_detail_skeleton.dart';
import 'package:momaspayplus/screens/stack_screens/service/actions/rating_widget.dart';
import 'package:momaspayplus/utils/colors.dart';

import '../../../../bloc/service_bloc/service_bloc.dart';
import '../../../../bloc/service_bloc/service_event.dart';
import '../../../../bloc/service_bloc/service_state.dart';
import '../../../../domain/data/response/comment_response.dart';
import '../../../../domain/repository/service_repository.dart';
import '../../../../reuseable/app_error_display.dart';
import '../../../../reuseable/error_modal.dart';
import '../../../../utils/service_launcher.dart';
import '../../../../utils/time_util.dart';

class ServicePreviewScreen extends StatefulWidget {
  final Artisan data;
  final String estate;

  const ServicePreviewScreen(
      {super.key, required this.data, required this.estate});

  @override
  State<ServicePreviewScreen> createState() => _ServicePreviewScreenState();
}

class _ServicePreviewScreenState extends State<ServicePreviewScreen> {
  late ServiceBloc serviceBloc;
  CommentResponse? response;

  @override
  void initState() {
    super.initState();
    serviceBloc = ServiceBloc(ServiceRepository())
      ..add(GetCommentEvent(widget.data.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return ActionDetailSkeleton(
      heading: 'Service',
      body: BlocConsumer<ServiceBloc, ServiceState>(
        bloc: serviceBloc,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactCard(widget.data),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Reviews',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: state is ServiceStateLoading
                    ? Center(
                  child: SpinKitFadingCircle(
                    color: MoColors.mainColor,
                    size: 40.0,
                  ),
                )
                    : response?.comment?.isEmpty ?? true
                    ? const Center(
                  child: Text(
                    "No reviews yet.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: response!.comment!.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final comment = response!.comment!.toList()[index];
                    return _buildCommentCard(
                      comment.userName ?? "",
                      comment.comment ?? "",
                      TimeUtil().ago(comment.createdAt ?? ""),
                      comment.rate ?? 0,
                    );
                  },
                ),
              ),
            ],
          );
        },
        listener: (BuildContext context, ServiceState state) {
          switch (state) {
            case ServiceGetChatStateSuccess():
              setState(() => response = state.response);
            case ServiceStateFailed():
              AppErrorDisplay.show(context, state.error);
            case ServiceSaveChatStateSuccess():
              showSuccessBottomSheet(context, state.message);
            default:
          }
        },
      ),
    );
  }

  Widget _buildContactCard(Artisan data) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: MoColors.mainColor.withOpacity(0.12),
            radius: 28,
            child: Icon(Icons.work_outline_rounded, size: 26, color: MoColors.mainColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.professionalName ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.serviceTitle ?? "",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 6),
                RatingStar(rating: data.rating ?? '0'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _actionButton(
                icon: Icons.chat_bubble_outline_rounded,
                color: MoColors.mainColor,
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => RatingModal(
                    onSubmit: (rating, comment) {
                      serviceBloc.add(ServicePostCommentEvent(
                        comment,
                        rating.toString(),
                        data.id.toString(),
                      ));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _actionButton(
                icon: Icons.phone_outlined,
                color: MoColors.mainColor,
                onTap: () => ServiceLauncher.makePhoneCall(data.professionalPhone ?? ""),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildCommentCard(String name, String comment, String minutesAgo, int rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: MoColors.mainColor.withOpacity(0.12),
            child:const Icon(Icons.person, color: MoColors.mainColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      minutesAgo,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                RatingStar(rating: rating.toString()),
                const SizedBox(height: 5),
                Text(
                  comment,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}