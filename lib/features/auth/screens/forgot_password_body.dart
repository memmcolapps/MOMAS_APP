import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:momaspayplus/features/auth/cubit/auth_view_cubit.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/mo_form.dart';

class ForgotPasswordBody extends StatelessWidget {
  final TextEditingController emailController;
  const ForgotPasswordBody({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        MoFormWidget(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(
            Icons.email,
            color: Colors.grey,
          ),
          title: "Email",
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Expanded(
                child: MoButton(
                  // isLoading: context
                  //     .watch<RegisterBloc>()
                  //     .state is RegisterLoading,
                  title: "CONTINUE",
                  onTap: () {
                    // context.read<RegisterBloc>().add(
                    //     CheckEmailEvent(
                    //         emailController.text,
                    //         widget.emailType));
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        TextButton(
          onPressed: () => context.read<AuthViewCubit>().showLogin(),
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}
