import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_golf_app/core/common/widgets/common_text_field.dart';
import 'package:social_golf_app/core/common/widgets/custom_button.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'bloc/sign_up_bloc.dart';
import 'bloc/sign_up_event.dart';
import 'bloc/sign_up_state.dart';
import '../../../core/utils/constants/enums.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: BlocConsumer<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state.status == ResponseStatus.success) {
            // context.push('/bottom-navigation');
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

  Widget _buildScreen(BuildContext context, SignUpState state) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back button with text
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
                      // Create your account heading
                      Text(
                        'Create your account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.black,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Join Social Golf today',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorConstants.grey,
                        ),
                      ),

                      const SizedBox(height: 32),

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
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        errorText: state.emailError,
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(EmailChanged(value));
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

                      const SizedBox(height: 20),

                      // Password Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Password TextField
                      CommonTextField(
                        controller: passwordController,
                        hintText: 'Min. 8 characters',
                        isObscure: !state.isPasswordVisible,
                        fillColor: ColorConstants.txtFieldBg,
                        borderColor: ColorConstants.textFieldBorder,
                        borderRadius: 12,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        errorText: state.passwordError,
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(
                            PasswordChanged(value),
                          );
                        },
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: ColorConstants.grey,
                            size: 20,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            context.read<SignUpBloc>().add(
                              TogglePasswordVisibility(),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Icon(
                              state.isPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: ColorConstants.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Confirm Password Label
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ColorConstants.black,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Confirm Password TextField
                      CommonTextField(
                        controller: confirmPasswordController,
                        hintText: 'Re-enter password',
                        isObscure: !state.isConfirmPasswordVisible,
                        fillColor: ColorConstants.txtFieldBg,
                        borderColor: ColorConstants.textFieldBorder,
                        borderRadius: 12,
                        textInputAction: TextInputAction.done,
                        maxLines: 1,
                        keyboardType: TextInputType.visiblePassword,
                        errorText: state.confirmPasswordError,
                        onChanged: (value) {
                          context.read<SignUpBloc>().add(
                            ConfirmPasswordChanged(value),
                          );
                        },
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: ColorConstants.grey,
                            size: 20,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            context.read<SignUpBloc>().add(
                              ToggleConfirmPasswordVisibility(),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Icon(
                              state.isConfirmPasswordVisible
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: ColorConstants.grey,
                              size: 20,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Create account Button
                      state.status == ResponseStatus.loading
                          ? Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: ColorConstants.btnColor,
                                borderRadius: BorderRadius.circular(48),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      ColorConstants.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : CustomButton(
                              onPressed: state.isFormValid
                                  ? () {
                                      context.read<SignUpBloc>().add(
                                        SignUpSubmitted(),
                                      );
                                    }
                                  : () {},
                              backgroundColor: state.isFormValid
                                  ? ColorConstants.btnColor
                                  : ColorConstants.btnColor.withOpacity(0.5),
                              btnText: 'Create account',
                              textColor: ColorConstants.white,
                            ),

                      const SizedBox(height: 24),

                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorConstants.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorConstants.btnColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
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
