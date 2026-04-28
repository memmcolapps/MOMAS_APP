// import 'dart:developer';
//
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
// import 'package:momaspayplus/features/auth/bloc/login/login_bloc.dart';
// import 'package:momaspayplus/bloc/registeration_bloc/register_event.dart';
// import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
// import 'package:momaspayplus/domain/repository/auth_repository.dart';
// import 'package:momaspayplus/domain/service/auth_service.dart';
// import 'package:momaspayplus/screens/auth/email_screen.dart';
// // import 'package:momaspayplus/screens/dashboard/root_screen.dart';
// import 'package:momaspayplus/tabs/root_screen.dart';
// import 'package:momaspayplus/utils/colors.dart';
// import 'package:momaspayplus/utils/screen_utils.dart';
// import 'package:momaspayplus/utils/shared_pref.dart';
//
// import '../../features/auth/bloc/login/login_event.dart';
// import '../../features/auth/bloc/login/login_state.dart';
// import '../../domain/data/request/login.dart';
// import '../../reuseable/error_modal.dart';
// import '../../reuseable/mo_button.dart';
// import '../../reuseable/mo_form.dart';
// import '../../utils/bio_metric_widget.dart';
// import '../../utils/images.dart';
// import '../../utils/validators.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController generalController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();
//     SharedPreferenceHelper.getLogin().then((onValue) {
//       setState(() {
//         if (onValue?.email != null) {
//           generalController.text = onValue!.email!;
//         }
//         if (onValue?.meterNo != null) {
//           generalController.text = onValue!.meterNo!;
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     context.read<TabCubit>().changeTab(0);
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.light,
//       child: Scaffold(
//         backgroundColor: MoColors.mainColorII,
//         body: BlocProvider(
//           create: (context) => LoginBloc(AuthService(AuthRepository())),
//           child: BlocConsumer<LoginBloc, LoginState>(
//             builder: (context, state) {
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       color: MoColors.scaffoldWhite,
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: MediaQuery.of(context).size.height * 0.4,
//                         decoration: const BoxDecoration(
//                           gradient: LinearGradient(
//                             stops: [0.5, 0.8],
//                             colors: [
//                               MoColors.mainColor,
//                               MoColors.mainColorII,
//                             ],
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                           ),
//                           borderRadius: BorderRadius.only(
//                               bottomRight: Radius.circular(100)),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Spacer(),
//                             Center(child: Image.asset(MoImage.logo)),
//                             const Spacer(),
//                             const Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Welcome Back",
//                                   style: TextStyle(
//                                       fontSize: 32, color: Colors.white),
//                                 ),
//                                 Text(
//                                   "Login",
//                                   style: TextStyle(
//                                       fontSize: 12, color: Colors.white),
//                                 )
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 30,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height * 0.6,
//                       decoration: const BoxDecoration(
//                         color: MoColors.scaffoldWhite,
//                         borderRadius:
//                             BorderRadius.only(topLeft: Radius.circular(100)),
//                       ),
//                       child: Padding(
//                         padding: context.isTablet
//                             ? EdgeInsets.symmetric(
//                                 horizontal:
//                                     MediaQuery.of(context).size.width * 0.2)
//                             : const EdgeInsets.all(0.0),
//                         child: Column(
//                           children: [
//                             const SizedBox(
//                               height: 100,
//                             ),
//                             MoFormWidget(
//                               controller: generalController,
//                               prefixIcon: const Icon(
//                                 Icons.email,
//                                 color: Colors.grey,
//                               ),
//                               title: "Email or Meter Number",
//                             ),
//                             MoFormWidget(
//                               controller: passwordController,
//                               prefixIcon: const Icon(
//                                 Icons.lock,
//                                 color: Colors.grey,
//                               ),
//                               title: "Password",
//                               isPassword: true,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 15),
//                               child: Row(
//                                 children: [
//                                   const Spacer(),
//                                   InkWell(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (_) => const EmailScreen(
//                                                     emailType:
//                                                         CheckEmail.forget,
//                                                   )));
//                                     },
//                                     child: const Text(
//                                       "Forgot Password",
//                                       style:
//                                           TextStyle(color: MoColors.mainColor),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 15),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: MoButton(
//                                       title: "LOGIN",
//                                       isLoading: context
//                                           .watch<LoginBloc>()
//                                           .state is LoginLoading,
//                                       onTap: () {
//                                         var meterNo = "";
//                                         var email = "";
//                                         if (FormValidators.isValidEmail(
//                                             generalController.text)) {
//                                           email = generalController.text;
//                                         } else {
//                                           meterNo = generalController.text;
//                                         }
//                                         final password =
//                                             passwordController.text;
//                                         final login = Login(
//                                             meterNo: meterNo,
//                                             password: password,
//                                             email: email);
//                                         context
//                                             .read<LoginBloc>()
//                                             .add(UserLoginEvent(login));
//                                       },
//                                     ),
//                                   ),
//                                   const SizedBox(
//                                     width: 10,
//                                   ),
//                                   BiometricLoginWidget(
//                                     onLoginSuccess: () {
//                                       SharedPreferenceHelper.getLogin()
//                                           .then((onValue) {
//                                         if (onValue != null) {
//                                           context
//                                               .read<LoginBloc>()
//                                               .add(UserLoginEvent(onValue));
//                                         }
//                                       });
//                                     },
//                                   )
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             // RichText(
//                             //   text: TextSpan(
//                             //     children: [
//                             //       const TextSpan(
//                             //         text: 'New on MOMAS PAY?  ',
//                             //         style: TextStyle(
//                             //             color: Colors.black, fontSize: 15),
//                             //       ),
//                             //       TextSpan(
//                             //         text: 'Register Here!',
//                             //         style: const TextStyle(
//                             //             color: MoColors.mainColor,
//                             //             fontSize: 14),
//                             //         recognizer: TapGestureRecognizer()
//                             //           ..onTap = () {
//                             //             Navigator.of(context).push(
//                             //                 MaterialPageRoute(
//                             //                     builder: (_) =>
//                             //                         const EmailScreen(
//                             //                           emailType:
//                             //                               CheckEmail.register,
//                             //                         )));
//                             //           },
//                             //       ),
//                             //     ],
//                             //   ),
//                             // )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             listener: (BuildContext context, LoginState state) {
//               switch (state) {
//                 case LoginFailure():
//                   showErrorBottomSheet(context, state.error);
//                 case LoginSuccess():
//                   context.read<AuthCubit>().loadUser();
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (_) => const RootScreen(
//                               // role: state.role,
//                               )),
//                       (v) => false);
//                 default:
//                   log("state not implemented");
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
