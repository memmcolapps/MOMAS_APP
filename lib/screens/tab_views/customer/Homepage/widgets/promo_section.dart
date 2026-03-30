import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/launcher.dart';
import 'package:shimmer/shimmer.dart';

class PromoSection extends StatelessWidget {
  // final double promoDivHeight;
  const PromoSection({super.key,
    // required this.promoDivHeight
  });

  // TODO: COME BACK HERE >>> IMPROPER WIDGET HANDLING
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 75,
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<PromoBloc, DashboardState>(
            builder: (context, state) {
          return SizedBox(
              height: 75,
              width: MediaQuery.of(context).size.width * 0.9,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                items: state is PromotionSuccessful
                    ? state.promo.map((value) {
                        return Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                              onTap: () => Launcher().launchInBrowser(
                                  Uri.parse(value.link!)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 1.0),
                                child: Image.network(
                                  value.url,
                                  fit: BoxFit.fill,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    // return Image.asset('assets/images/fallback.png');
                                    return _widgetPromo(context);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }).toList()
                    : List.generate(4, (i) => _widgetPromo(context))
                        .map((widget) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              child: widget,
                            );
                          },
                        );
                      }).toList(),
              ));
        }),
      ),
    );
  }

  Widget _widgetPromo(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          height: 75,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
