import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_golf_app/core/common/widgets/common_text_field.dart';
import 'package:social_golf_app/core/common/widgets/custom_button.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/core/utils/constants/image_strings.dart';
import 'bloc/sign_in_bloc.dart';
import 'bloc/sign_in_event.dart';
import 'bloc/sign_in_state.dart';
import '../../../core/utils/constants/enums.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state.status == ResponseStatus.success) {
            context.push('/bottom-navigation');
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

  Widget _buildScreen(BuildContext context, SignInState state) {
    return Scaffold(
      backgroundColor: ColorConstants.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: ColorConstants.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: ColorConstants.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(ImageStrings.logo, fit: BoxFit.contain),
                ),
              ),

              const SizedBox(height: 32),

              // Welcome Text
              const Text(
                'Welcome to Social Golf',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.black,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Sign in to continue',
                style: TextStyle(fontSize: 16, color: ColorConstants.grey),
              ),

              const SizedBox(height: 32),

              // Email Label and TextField
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

              CommonTextField(
                controller: emailController,
                hintText: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                fillColor: ColorConstants.txtFieldBg,
                borderColor: ColorConstants.textFieldBorder,
                maxLines: 1,
                borderRadius: 12,
                textInputAction: TextInputAction.next,
                errorText: state.emailError,
                onChanged: (value) {
                  context.read<SignInBloc>().add(EmailChanged(value));
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

              // Password Label and TextField
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

              CommonTextField(
                controller: passwordController,
                hintText: '••••••••',
                isObscure: !state.isPasswordVisible,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                fillColor: ColorConstants.txtFieldBg,
                borderColor: ColorConstants.textFieldBorder,
                borderRadius: 12,
                errorText: state.passwordError,
                onChanged: (value) {
                  context.read<SignInBloc>().add(PasswordChanged(value));
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
                    context.read<SignInBloc>().add(TogglePasswordVisibility());
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

              const SizedBox(height: 32),

              // Sign In Button
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
                              context.read<SignInBloc>().add(SignInSubmitted());
                            }
                          : () {},
                      backgroundColor: state.isFormValid
                          ? ColorConstants.btnColor
                          : ColorConstants.btnColor.withOpacity(0.5),
                      btnText: 'Sign in',
                      textColor: ColorConstants.white,
                    ),

              const SizedBox(height: 24),

              // OR Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(color: ColorConstants.border, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstants.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: ColorConstants.border, thickness: 1),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Continue with Google Button
              GestureDetector(
                onTap: () {
                  // Handle Google sign in
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorConstants.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: ColorConstants.border, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      ImageStrings.googleIcon,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Forgot Password and Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/forgot-password');
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorConstants.grey,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Need an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.grey,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/signup');
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 14,
                            color: ColorConstants.btnColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
