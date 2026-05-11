import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/service_bloc/service_state.dart';
import 'package:momaspayplus/domain/data/response/artisan_list_response.dart';
import 'package:momaspayplus/domain/data/response/service_data_response.dart';
import 'package:momaspayplus/domain/data/response/service_type_response.dart';
import 'package:momaspayplus/domain/repository/service_repository.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/rating_star.dart';
import 'package:momaspayplus/screens/stack_screens/service/actions/service_preview.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../../bloc/service_bloc/service_bloc.dart';
import '../../../bloc/service_bloc/service_event.dart';
import '../../../domain/data/response/service_response.dart';
import '../../../domain/data/response/user_model.dart';
import '../../../reuseable/error_modal.dart';
import '../../../reuseable/search_bottom_sheet/ka_dropdown.dart';
import '../../../core/storage/shared_pref.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late ServiceBloc serviceBloc;
  Estate? selectedEstate;
  ServiceType? selectedService;
  ServiceTypeResponse? serviceTypeResponse;
  ArtisanListResponse? artisanListResponse;
  String? estateId;

  @override
  void initState() {
    super.initState();
    serviceBloc = ServiceBloc(ServiceRepository())
      ..add(const ServiceTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      heading: "Service",
      body: BlocConsumer<ServiceBloc, ServiceState>(
        bloc: serviceBloc,
        builder: (context, state) {
          // loading message depends on what we're waiting for
          final loadingMessage = selectedService == null
              ? 'Fetching services...'
              : 'Fetching professionals...';

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: context.isTablet
                      ? EdgeInsets.symmetric(
                      horizontal:
                      MediaQuery.of(context).size.width * 0.15)
                      : const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EPDropdownButton<ServiceType>(
                        itemsListTitle: "Choose Services",
                        iconSize: 22,
                        value: selectedService,
                        hint: const Text(
                          "Choose a service type",
                          style: TextStyle(fontSize: 14),
                        ),
                        isExpanded: true,
                        underline: const Divider(),
                        searchMatcher: (item, text) => item.serviceTitle!
                            .toLowerCase()
                            .contains(text.toLowerCase()),
                        onChanged: (v) {
                          setState(() => selectedService = v);
                          serviceBloc
                              .add(ArtisanListEvent(selectedService!.id));
                        },
                        items: (serviceTypeResponse?.data ?? [])
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.serviceTitle.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      MoButton(
                        isLoading: state is ServiceStateLoading,
                        title: "Search",
                        onTap: () {
                          if (selectedService == null) return;
                          serviceBloc
                              .add(ArtisanListEvent(selectedService!.id));
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              artisanListResponse?.data?.artisans?.isNotEmpty == true
                  ? SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final artisan =
                      artisanListResponse!.data!.artisans![index];
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ServicePreviewScreen(
                              data: artisan,
                              estate: selectedEstate?.title ?? "",
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        child: CustomListItem(
                          name: artisan.professionalName ?? "",
                          profession: artisan.serviceTitle ?? "",
                          rating: artisan.rating ?? "0",
                          phoneNumber: artisan.professionalPhone ?? "",
                        ),
                      );
                    },
                    childCount:
                    artisanListResponse!.data!.artisans!.length,
                  ),
                ),
              )
                  : SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyList(
                  selectedService: selectedService,
                  loadingMessage: loadingMessage,
                  isLoading: state is ServiceStateLoading,
                ),
              ),
            ],
          );
        },
        listener: (BuildContext context, ServiceState state) {
          switch (state) {
            case ServiceStateFailed():
              showErrorBottomSheet(context, state.error);
            case ServiceTypeSuccess():
              setState(() => serviceTypeResponse = state.dataResponse);
            case ArtisanListSuccess():
              setState(() => artisanListResponse = state.dataResponse);
            default:
              log("state not implemented");
          }
        },
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  final String name;
  final String profession;
  final String phoneNumber;
  final String rating;

  const CustomListItem({
    super.key,
    required this.name,
    required this.profession,
    required this.rating,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: MoColors.mainColor.withOpacity(0.12),
            child: Icon(
              Icons.work_outline_rounded,
              color: MoColors.mainColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  profession,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                RatingStar(rating: rating),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  final ServiceType? selectedService;
  final bool isLoading;
  final String? loadingMessage;

  const EmptyList({
    super.key,
    this.selectedService,
    required this.isLoading,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLoading
                  ? Icons.manage_search_rounded
                  : Icons.person_search_rounded,
              size: 52,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              isLoading
                  ? (loadingMessage ?? "Fetching...")
                  : selectedService != null
                  ? "No professionals available\nfor this service."
                  : "Select a service type to view\navailable professionals.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}