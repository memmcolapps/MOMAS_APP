import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momaspayplus/domain/data/model/page_data.dart';
import 'package:momaspayplus/features/auth/screens/auth_screen.dart';
import 'package:momaspayplus/features/onboarding/screens/intro_dot.dart';
import 'package:momaspayplus/reuseable/buttons/secondary_button.dart';
import 'package:momaspayplus/screens/auth/login.dart';
import 'package:momaspayplus/core/storage/shared_pref.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // TODO(DON): Extract this data
  final List<PageData> onboardData = [
    PageData(
        imageUrl: 'assets/family.png',
        title: 'EASY AND SWIFT',
        description:
            'Managing your electricity bills just got easier. Pay, track, and manage all your utility payments in one place, anytime, anywhere.'),
    PageData(
        imageUrl: 'assets/thinking.png',
        title: 'FRIENDLY AND ENGAGING',
        description:
            'We\'re excited to have you on Momaspay. Say goodbye to long queues and missed deadlines—pay your electric bills with just a few taps. Let\'s get started!'),
    PageData(
        imageUrl: 'assets/technician.png',
        title: 'GETTING SERVICES',
        description:
            'Momaspay helps you easily locate the best service providers around you.')
  ];

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _getStarted() async {
    await SharedPreferenceHelper.setOnboardingSeen(true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AuthScreen(),
        transitionDuration: const Duration(milliseconds: 650),
      ),
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets safePadding = MediaQuery.paddingOf(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          backgroundColor: Colors.green[700],
          body: Stack(
            children: [
              PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: onboardData.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Image.asset(
                        onboardData[index].imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
              Positioned(
                top: safePadding.top,
                right: 20,
                // TODO (DON): Extract this button to reusable
                child: TextButton(
                  onPressed: _getStarted,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  //TODO (DON): Let the content breathe... use safePadding for bottom,
                  height: MediaQuery.sizeOf(context).height * 0.34,
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.green[700],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      double page = 0;
                      if (_pageController.hasClients &&
                          _pageController.page != null) {
                        page = _pageController.page!;
                      }
                      int index = page.round().clamp(0, onboardData.length - 1);
                      final data = onboardData[index];

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onboardData.length,
                              (dotIndex) => IntroDot(
                                currentIndex: _currentIndex,
                                index: dotIndex,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            data.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            data.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const Spacer(),
                          SecondaryButton(
                            title: index == onboardData.length - 1
                                ? 'Get Started'
                                : 'Next',
                            onPressed: index == onboardData.length - 1
                                ? _getStarted
                                : _next,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}