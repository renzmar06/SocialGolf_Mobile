import 'package:social_golf_app/core/bloc/base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';
import '../../../../core/utils/constants/enums.dart';

class SignUpBloc extends BaseBloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<ConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<ToggleConfirmPasswordVisibility>(_onToggleConfirmPasswordVisibility);
  }

  // Email validation
  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  // Confirm password validation
  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Check if form is valid
  bool _isFormValid(
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String email,
    String password,
    String confirmPassword,
  ) {
    return emailError == null &&
        passwordError == null &&
        confirmPasswordError == null &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty;
  }

  // Email changed event handler
  void _onEmailChanged(EmailChanged event, Emitter<SignUpState> emit) {
    final emailError = _validateEmail(event.email);
    final isValid = _isFormValid(
      emailError,
      state.passwordError,
      state.confirmPasswordError,
      event.email,
      state.password,
      state.confirmPassword,
    );

    emit(
      state.copyWith(
        email: event.email,
        emailError: emailError,
        isFormValid: isValid,
      ),
    );
  }

  // Password changed event handler
  void _onPasswordChanged(PasswordChanged event, Emitter<SignUpState> emit) {
    final passwordError = _validatePassword(event.password);
    final confirmPasswordError = _validateConfirmPassword(
      event.password,
      state.confirmPassword,
    );
    final isValid = _isFormValid(
      state.emailError,
      passwordError,
      confirmPasswordError,
      state.email,
      event.password,
      state.confirmPassword,
    );

    emit(
      state.copyWith(
        password: event.password,
        passwordError: passwordError,
        confirmPasswordError: confirmPasswordError,
        isFormValid: isValid,
      ),
    );
  }

  // Confirm password changed event handler
  void _onConfirmPasswordChanged(
    ConfirmPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final confirmPasswordError = _validateConfirmPassword(
      state.password,
      event.confirmPassword,
    );
    final isValid = _isFormValid(
      state.emailError,
      state.passwordError,
      confirmPasswordError,
      state.email,
      state.password,
      event.confirmPassword,
    );

    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
        confirmPasswordError: confirmPasswordError,
        isFormValid: isValid,
      ),
    );
  }

  // Toggle password visibility
  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  // Toggle confirm password visibility
  void _onToggleConfirmPasswordVisibility(
    ToggleConfirmPasswordVisibility event,
    Emitter<SignUpState> emit,
  ) {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  // Sign up submitted event handler
  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    try {
      // Validate all fields
      final emailError = _validateEmail(state.email);
      final passwordError = _validatePassword(state.password);
      final confirmPasswordError = _validateConfirmPassword(
        state.password,
        state.confirmPassword,
      );

      if (emailError != null ||
          passwordError != null ||
          confirmPasswordError != null) {
        emit(
          state.copyWith(
            emailError: emailError,
            passwordError: passwordError,
            confirmPasswordError: confirmPasswordError,
            status: ResponseStatus.failure,
            errorMessage: 'Please fix the errors before submitting',
          ),
        );
        return;
      }

      // emit(state.copyWith(status: ResponseStatus.inProgress));
      emit(state.copyWith(status: ResponseStatus.loading));

      // TODO: Implement actual sign up logic here
      // Example:
      // final response = await authRepository.signUp(
      //   email: state.email,
      //   password: state.password,
      // );
      //
      // response.fold(
      //   (failure) {
      //     ErrorModel error = handleException(failure);
      //     emit(
      //       state.copyWith(
      //         status: ResponseStatus.failure,
      //         errorMessage: error.message,
      //       ),
      //     );
      //   },
      //   (data) {
      //     emit(
      //       state.copyWith(
      //         status: ResponseStatus.success,
      //       ),
      //     );
      //   },
      // );

      // Temporary success for testing
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: ResponseStatus.success));
    } catch (e, s) {
      logger.e("Sign up error: $e", s);
      emit(
        state.copyWith(
          status: ResponseStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
