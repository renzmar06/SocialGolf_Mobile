import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_golf_app/core/common/widgets/common_text_field.dart';
import 'package:social_golf_app/core/common/widgets/custom_button.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'bloc/forgot_password_bloc.dart';
import 'bloc/forgot_password_event.dart';
import 'bloc/forgot_password_state.dart';
import '../../../core/utils/constants/enums.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ResponseStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage ?? 'Reset link sent!'),
                backgroundColor: Colors.green,
              ),
            );
            // Optionally pop back after success
            Future.delayed(const Duration(seconds: 2), () {
              if (context.mounted) {
                context.pop();
              }
            });
          } else if (state.status == ResponseStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          return _buildScreen(context, state);
        },
      ),
    );
  }

  Widget _buildScreen(BuildContext context, ForgotPasswordState state) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button aligned to the left
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: ColorConstants.black,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Centered content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Reset your password heading
                      Text(
                        'Reset your password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        'Enter your email and we\'ll send you a link to reset\nyour password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.grey,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Email Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Email TextField
                      CommonTextField(
                        controller: emailController,
                        hintText: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        fillColor: ColorConstants.txtFieldBg,
                        borderColor: ColorConstants.textFieldBorder,
                        borderRadius: 12,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        errorText: state.emailError,
                        onChanged: (value) {
                          context.read<ForgotPasswordBloc>().add(
                            EmailChanged(value),
                          );
                        },
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Icon(
                            Icons.email_outlined,
                            color: ColorConstants.grey,
                            size: 20,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Send reset link Button
                      CustomButton(
                        onPressed: state.isFormValid
                            ? () {
                                context.read<ForgotPasswordBloc>().add(
                                  ResetPasswordSubmitted(),
                                );
                              }
                            : () {},
                        backgroundColor: state.isFormValid
                            ? ColorConstants.btnColor
                            : ColorConstants.btnColor.withOpacity(0.5),
                        btnText: state.status == ResponseStatus.inProgress
                            ? 'Sending...'
                            : 'Send reset link',
                        textColor: ColorConstants.white,
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
