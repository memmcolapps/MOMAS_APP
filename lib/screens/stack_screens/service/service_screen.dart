import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:momaspayplus/bloc/service_bloc/service_state.dart';
import 'package:momaspayplus/domain/data/response/artisan_list_response.dart';
import 'package:momaspayplus/domain/data/response/service_type_response.dart';
import 'package:momaspayplus/domain/repository/service_repository.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/rating_star.dart';
import 'package:momaspayplus/screens/stack_screens/service/actions/service_preview.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../../bloc/service_bloc/service_bloc.dart';
import '../../../bloc/service_bloc/service_event.dart';
import '../../../domain/data/response/service_data_response.dart';
import '../../../domain/data/response/service_response.dart';
import '../../../domain/data/response/user_model.dart';
import '../../../reuseable/error_modal.dart';
import '../../../reuseable/pop_button.dart';
import '../../../reuseable/search_bottom_sheet/ka_dropdown.dart';
import '../../../reuseable/shadow_container.dart';
import '../../../utils/service_launcher.dart';
import '../../../utils/shared_pref.dart';

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
  // ServiceDataResponse? serviceDataResponse;
  // ServiceSearchResponse? serviceSearchResponse;
  String? estateId;

  @override
  void initState() {
    super.initState();
    serviceBloc = ServiceBloc(ServiceRepository())
      ..add(const ServiceTypeEvent());
    // ..add(const ServicePropertiesEvent());
    // getUserEstate();
  }

  getUserEstate() async {
    User? user = await SharedPreferenceHelper.getUser();
    estateId = user?.estateId;
  }

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      heading: "Service",
      body: BlocConsumer<ServiceBloc, ServiceState>(
        bloc: serviceBloc,
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // const SizedBox(height: 20),
                    // Center(
                    //   child: ShadowContainer(
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 10, horizontal: 8),
                    //       child: SizedBox(
                    //         height: 40,
                    //         width: MediaQuery.of(context).size.width - 15,
                    //         child: Row(
                    //           children: [
                    //             PopButton().pop(context),
                    //             const SizedBox(
                    //               width: 20,
                    //             ),
                    //             const Text("Service")
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // EPDropdownButton<Estate>(
                    //   itemsListTitle: "Choose Estate",
                    //   iconSize: 22,
                    //   value: selectedEstate,
                    //   hint: const Text(""),
                    //   isExpanded: true,
                    //   underline: const Divider(),
                    //   searchMatcher: (item, text) {
                    //     return item.title!
                    //         .toLowerCase()
                    //         .contains(text.toLowerCase());
                    //   },
                    //   onChanged: (v) {
                    //     setState(() {
                    //       selectedEstate = v;
                    //     });
                    //   },
                    //   items: (serviceDataResponse?.data?.estate ?? [])
                    //       .map(
                    //         (e) => DropdownMenuItem(
                    //           value: e,
                    //           child: Row(
                    //             children: [
                    //               Text(e.title.toString(),
                    //                   style: Theme.of(context)
                    //                       .textTheme
                    //                       .labelMedium!
                    //                       .copyWith(
                    //                           fontWeight: FontWeight.w400,
                    //                           color: Colors.black)),
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //       .toList(),
                    // ),
                    Padding(
                      padding: context.isTablet
                          ? EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.15)
                          : const EdgeInsets.all(0.0),
                      child: Column(
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
                            searchMatcher: (item, text) {
                              return item.serviceTitle!
                                  .toLowerCase()
                                  .contains(text.toLowerCase());
                            },
                            onChanged: (v) {
                              setState(() {
                                selectedService = v;
                              });
                              serviceBloc.add(ArtisanListEvent(
                                  // estateId.toString(),
                                  selectedService!.id));
                            },
                            items: (serviceTypeResponse?.data ?? [])
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Text(e.serviceTitle.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: MoButton(
                              isLoading: state is ServiceStateLoading,
                              title: "Search",
                              onTap: () {
                                serviceBloc.add(ArtisanListEvent(
                                    // estateId.toString(),
                                    selectedService!.id));
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              artisanListResponse?.data?.artisans?.isNotEmpty == true
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (artisanListResponse
                                  ?.data?.artisans?.isNotEmpty ==
                              true) {
                            var artisanList =
                                artisanListResponse!.data!.artisans![index];
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ServicePreviewScreen(
                                              data: artisanList,
                                              estate:
                                                  selectedEstate?.title ??
                                                      "",
                                            )));
                              },
                              child: CustomListItem(
                                name: artisanList.professionalName ?? "",
                                profession: artisanList.serviceTitle ?? "",
                                rating: artisanList.rating ?? "0",
                                phoneNumber:
                                    artisanList.professionalPhone ?? "",
                              ),
                            );
                          }
                          return EmptyList(
                            selectedService: null,
                            isLoading: state is ServiceStateLoading,
                          );
                        },
                        childCount:
                            artisanListResponse?.data?.artisans?.length ??
                                0,
                      ),
                    )
                  : SliverToBoxAdapter(
                      child: EmptyList(
                      selectedService: selectedService,
                      isLoading: state is ServiceStateLoading,
                    )),
            ],
          );
        },
        listener: (BuildContext context, ServiceState state) {
          switch (state) {
            // case ServiceSearchStateSuccess():
            //   serviceSearchResponse = state.dataResponse;
            case ServiceStateFailed():
              showErrorBottomSheet(context, state.error);
            // case ServiceStateSuccess():
            //   serviceDataResponse = state.dataResponse;
            case ServiceTypeSuccess():
              serviceTypeResponse = state.dataResponse;
            case ArtisanListSuccess():
              artisanListResponse = state.dataResponse;

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
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: const Icon(Icons.work, color: Colors.green),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    RatingStar(rating: rating),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  profession,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(width: 8.0),
          // InkWell(
          //     onTap: () => ServiceLauncher.makePhoneCall(phoneNumber),
          //     child: const Icon(Icons.phone, color: Colors.green)),
        ],
      ),
    );
  }
}

class EmptyList extends StatelessWidget {
  final ServiceType? selectedService;
  final bool isLoading;

  const EmptyList({super.key, this.selectedService, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_search_sharp,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 5),
            isLoading ? const Text(
              "Fetching services...",
            ) :
            selectedService != null
                ? const Text(
                    'No professional available',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  )
                : const Text(
                    "Select a service type to view available professionals.",
                  ),
          ],
        ),
      ),
    );
  }
}
