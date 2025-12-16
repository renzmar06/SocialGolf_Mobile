import 'package:social_golf_app/core/bloc/base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';
import '../../../../core/utils/constants/enums.dart';

class ForgotPasswordBloc
    extends BaseBloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(const ForgotPasswordState()) {
    on<EmailChanged>(_onEmailChanged);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
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

  // Check if form is valid
  bool _isFormValid(String? emailError, String email) {
    return emailError == null && email.isNotEmpty;
  }

  // Email changed event handler
  void _onEmailChanged(EmailChanged event, Emitter<ForgotPasswordState> emit) {
    final emailError = _validateEmail(event.email);
    final isValid = _isFormValid(emailError, event.email);

    emit(
      state.copyWith(
        email: event.email,
        emailError: emailError,
        isFormValid: isValid,
      ),
    );
  }

  // Reset password submitted event handler
  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    try {
      // Validate email
      final emailError = _validateEmail(state.email);

      if (emailError != null) {
        emit(
          state.copyWith(
            emailError: emailError,
            status: ResponseStatus.failure,
            errorMessage: 'Please fix the errors before submitting',
          ),
        );
        return;
      }

      emit(state.copyWith(status: ResponseStatus.inProgress));

      // TODO: Implement actual forgot password logic here
      // Example:
      // final response = await authRepository.resetPassword(
      //   email: state.email,
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
      //         successMessage: 'Password reset link sent to your email',
      //       ),
      //     );
      //   },
      // );

      // Temporary success for testing
      await Future.delayed(const Duration(seconds: 2));
      emit(
        state.copyWith(
          status: ResponseStatus.success,
          successMessage: 'Password reset link sent to your email',
        ),
      );
    } catch (e, s) {
      logger.e("Reset password error: $e", s);
      emit(
        state.copyWith(
          status: ResponseStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
