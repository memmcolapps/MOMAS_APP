import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/screens/generate_token/widget/token_tile_view.dart';

import '../../bloc/access_token_bloc/access_token_bloc.dart';
import '../../bloc/access_token_bloc/access_token_event.dart';
import '../../bloc/access_token_bloc/access_token_state.dart';
import '../../domain/data/response/access_token_list_data.dart';
import '../../domain/repository/access_token_repository.dart';
import '../../reuseable/app_error_display.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_form.dart';
import '../../utils/colors.dart';

class AccessTokenVerification extends StatefulWidget {
  const AccessTokenVerification({
    super.key,
    this.rootApp = false,
  });

  final bool? rootApp;

  @override
  State<AccessTokenVerification> createState() =>
      _AccessTokenVerificationState();
}

class _AccessTokenVerificationState
    extends State<AccessTokenVerification>
    with SingleTickerProviderStateMixin {
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  late AccessTokenBloc accessTokenBloc;

  List<TokenBody> tokenList = [];
  List<TokenBody> filteredTokenList = [];

  // ==============================
  // SWIPE GUIDE
  // ==============================
  bool _showSwipeGuide = true;

  late AnimationController _swipeAnimationController;
  late Animation<double> _swipeAnimation;

  @override
  void initState() {
    super.initState();

    accessTokenBloc = AccessTokenBloc(
      repository: AccessTokenRepository(),
    );

    accessTokenBloc.add(
      const GetEstateTokenList(),
    );

    searchController.addListener(_onSearchChanged);

    // ==============================
    // SWIPE ANIMATION
    // ==============================
    _swipeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _swipeAnimation = Tween<double>(
      begin: -55,
      end: 55,
    ).animate(
      CurvedAnimation(
        parent: _swipeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Repeat left -> right -> left
    _swipeAnimationController.repeat(
      reverse: true,
    );

    // Automatically hide after a few seconds
    Future.delayed(
      const Duration(seconds: 5),
          () {
        if (mounted) {
          _hideSwipeGuide();
        }
      },
    );
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    tokenController.dispose();

    _swipeAnimationController.dispose();
    accessTokenBloc.close();

    super.dispose();
  }

  void _onSearchChanged() {
    final searchText = searchController.text.toLowerCase();

    setState(() {
      filteredTokenList = tokenList.where((token) {
        return token.token.toLowerCase().contains(searchText);
      }).toList();
    });
  }

  Future<void> _refreshTokenList() async {
    accessTokenBloc.add(
      const GetEstateTokenList(),
    );
  }

  void _removeTokenFromList(TokenBody tokenBody) {
    setState(() {
      tokenList.removeWhere(
            (token) => token.id == tokenBody.id,
      );

      filteredTokenList.removeWhere(
            (token) => token.id == tokenBody.id,
      );
    });
  }

  void _hideSwipeGuide() {
    if (!mounted) return;

    setState(() {
      _showSwipeGuide = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verify Access Token",
        ),
      ),

      body: Stack(
        children: [
          // =====================================================
          // MAIN PAGE
          // =====================================================
          BlocConsumer<AccessTokenBloc, AccessTokenState>(
            bloc: accessTokenBloc,

            listener: (BuildContext context, AccessTokenState state) {
              switch (state) {
                case AccessTokenFailed():
                  AppErrorDisplay.show(
                    context,
                    state.error,
                  );
                  break;

                case GetTokenListSuccess():
                  setState(() {
                    tokenList = state.data;

                    final searchText =
                    searchController.text.toLowerCase();

                    filteredTokenList = tokenList.where((token) {
                      return token.token
                          .toLowerCase()
                          .contains(searchText);
                    }).toList();
                  });
                  break;

                case VerifyTokenSuccess():
                  showSuccessBottomSheet(
                    context,
                    state.message,
                  );
                  break;

                default:
                  break;
              }
            },

            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // SEARCH
                    MoFormWidget(
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      prefixIcon: const Icon(
                        Icons.token,
                        color: Colors.grey,
                      ),
                      title: "Search tokens..",
                    ),

                    const SizedBox(height: 10),

                    // SWIPE INSTRUCTION
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MoColors.ticketWarning
                            .withOpacity(0.2),
                      ),
                      child: const Text(
                        "Swipe left to disapprove | "
                            "Swipe right to validate",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MoColors.flareRed,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // LOADING
                    if (state is AccessTokenLoading)
                      Expanded(
                        child: Center(
                          child: SpinKitFadingCircle(
                            color: MoColors.mainColor,
                            size: 40.0,
                          ),
                        ),
                      )

                    // EMPTY
                    else if (filteredTokenList.isEmpty)
                      const Expanded(
                        child: Center(
                          child: Text(
                            "No tokens found",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )

                    // TOKEN LIST
                    else
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refreshTokenList,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount:
                            filteredTokenList.length,
                            itemBuilder:
                                (context, index) {
                              final tokenBody =
                              filteredTokenList[index];

                              return Dismissible(
                                key: Key(
                                  tokenBody.id.toString(),
                                ),

                                // =================================
                                // SWIPE RIGHT
                                // =================================
                                background: Container(
                                  margin:
                                  const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color: Colors.green,
                                    borderRadius:
                                    BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  alignment:
                                  Alignment.centerLeft,
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),

                                // =================================
                                // SWIPE LEFT
                                // =================================
                                secondaryBackground:
                                Container(
                                  margin:
                                  const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                    BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  alignment:
                                  Alignment.centerRight,
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),

                                confirmDismiss:
                                    (direction) async {
                                  // Hide tutorial once
                                  // the user actually swipes.
                                  _hideSwipeGuide();

                                  // Remove from UI
                                  _removeTokenFromList(
                                    tokenBody,
                                  );

                                  // ==========================
                                  // SWIPE RIGHT
                                  // ==========================
                                  if (direction ==
                                      DismissDirection
                                          .startToEnd) {
                                    accessTokenBloc.add(
                                      VerifyAccessToken(
                                        tokenBody.id.toString(),
                                      ),
                                    );
                                  }

                                  // ==========================
                                  // SWIPE LEFT
                                  // ==========================
                                  else if (direction ==
                                      DismissDirection
                                          .endToStart) {
                                    accessTokenBloc.add(
                                      DisApproveToken(
                                        tokenBody.id.toString(),
                                      ),
                                    );
                                  }

                                  return false;
                                },

                                child: TokenTileView(
                                  tokenBody: tokenBody,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),

          // =====================================================
          // SWIPE GUIDE OVERLAY
          // =====================================================
          if (_showSwipeGuide)
            Positioned.fill(
              child: GestureDetector(
                onTap: _hideSwipeGuide,
                child: Container(
                  color: Colors.black.withOpacity(0.55),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Swipe to take action",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // ==============================
                        // SWIPE ANIMATION
                        // ==============================
                        AnimatedBuilder(
                          animation:
                          _swipeAnimationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(
                                _swipeAnimation.value,
                                0,
                              ),
                              child: child,
                            );
                          },
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.touch_app,
                              size: 65,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            // LEFT
                            Column(
                              children: const [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.red,
                                  size: 35,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Disapprove",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(width: 70),

                            // RIGHT
                            Column(
                              children: const [
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Validate",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 35),

                        // CLOSE BUTTON
                        TextButton(
                          onPressed: _hideSwipeGuide,
                          child: const Text(
                            "Got it",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
//
// class AccessTokenVerification extends StatefulWidget {
//   const AccessTokenVerification({super.key, this.rootApp = false});
//   final bool? rootApp;
//
//   @override
//   State<AccessTokenVerification> createState() =>
//       _AccessTokenVerificationState();
// }
//
// class _AccessTokenVerificationState extends State<AccessTokenVerification> {
//   final TextEditingController tokenController = TextEditingController();
//   final TextEditingController searchController = TextEditingController();
//   late AccessTokenBloc accessTokenBloc;
//   List<TokenBody> tokenList = [];
//   List<TokenBody> filteredTokenList = [];
//
//   @override
//   void initState() {
//     accessTokenBloc = AccessTokenBloc(repository: AccessTokenRepository());
//     accessTokenBloc.add(const GetEstateTokenList());
//     searchController.addListener(_onSearchChanged);
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     tokenController.dispose();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       filteredTokenList = tokenList
//           .where((token) => token.token
//               .toLowerCase()
//               .contains(searchController.text.toLowerCase()))
//           .toList();
//     });
//   }
//
//   Future<void> _refreshTokenList() async {
//     accessTokenBloc.add(const GetEstateTokenList());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Verify Access Token"),
//       ),
//       body: BlocConsumer<AccessTokenBloc, AccessTokenState>(
//         bloc: accessTokenBloc,
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 MoFormWidget(
//                   controller: searchController,
//                   keyboardType: TextInputType.text,
//                   prefixIcon: const Icon(
//                     Icons.token,
//                     color: Colors.grey,
//                   ),
//                   title: "Search tokens..",
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                       color: MoColors.ticketWarning.withOpacity(0.2)
//                   ),
//                     child: const Text("Swipe left to disapprove | Swipe right to validate",
//                       style: TextStyle(color: MoColors.flareRed),)),
//                 state is AccessTokenLoading
//                     ? const Center(
//                         child: SpinKitFadingCircle(
//                         color: MoColors.mainColor,
//                         size: 40.0,
//                       ))
//                     : Expanded(
//                         child: RefreshIndicator(
//                           onRefresh: _refreshTokenList,
//                           child: ListView.builder(
//                             padding: const EdgeInsets.all(16),
//                             itemCount: filteredTokenList.length,
//                             itemBuilder: (context, index) {
//                               final tokenBody = filteredTokenList[index];
//                               return Dismissible(
//                                 key: Key(tokenBody.token),
//                                 background: Container(
//                                   color: Colors.green,
//                                   alignment: Alignment.centerRight,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 20),
//                                   child: const Icon(Icons.approval,
//                                       color: Colors.white),
//                                 ),
//                                 confirmDismiss: (direction) async {
//                                   if (direction ==
//                                       DismissDirection.startToEnd) {
//                                     accessTokenBloc.add(VerifyAccessToken(
//                                         tokenBody.id.toString()));
//                                     return true;
//                                   } else if (direction ==
//                                       DismissDirection.endToStart) {
//                                     accessTokenBloc.add(DisApproveToken(
//                                         tokenBody.id.toString()));
//
//                                     return false;
//                                   }
//                                   return false;
//                                 },
//                                 child: TokenTileView(tokenBody: tokenBody),
//                               );
//                             },
//                           ),
//                         ),
//                       )
//               ],
//             ),
//           );
//         },
//         listener: (BuildContext context, AccessTokenState state) {
//           switch (state) {
//             case AccessTokenFailed():
//               AppErrorDisplay.show(context, state.error);
//             case GetTokenListSuccess():
//               setState(() {
//                 tokenList = state.data;
//                 filteredTokenList = tokenList;
//               });
//               break;
//             case VerifyTokenSuccess():
//               showSuccessBottomSheet(context, state.message);
//               break;
//             default:
//           }
//         },
//       ),
//     );
//   }
// }
