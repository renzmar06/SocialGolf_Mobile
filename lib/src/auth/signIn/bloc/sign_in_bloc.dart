// import 'package:social_golf_app/core/bloc/base_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../core/di/injection_container_common.dart';
// import '../../../../core/network/network_call/domain/repository/auth_repository.dart';
// import '../../../../core/shared_pref/preferences_utils.dart';
// import 'sign_in_event.dart';
// import 'sign_in_state.dart';
// import '../../../../core/utils/constants/enums.dart';
//
// class SignInBloc extends BaseBloc<SignInEvent, SignInState> {
//   final AuthRepository authRepository;
//   final pref = serviceLocator<PreferencesUtil>();
//   SignInBloc({required this.authRepository}) : super(const SignInState()) {
//     on<EmailChanged>(_onEmailChanged);
//     on<PasswordChanged>(_onPasswordChanged);
//     on<SignInSubmitted>(_onSignInSubmitted);
//     on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
//   }
//
//   // Email validation
//   String? _validateEmail(String email) {
//     if (email.isEmpty) {
//       return 'Email is required';
//     }
//
//     // Basic email regex pattern
//     final emailRegex = RegExp(
//       r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
//     );
//
//     if (!emailRegex.hasMatch(email)) {
//       return 'Please enter a valid email address';
//     }
//
//     return null;
//   }
//
//   // Password validation
//   String? _validatePassword(String password) {
//     if (password.isEmpty) {
//       return 'Password is required';
//     }
//
//     if (password.length < 8) {
//       return 'Password must be at least 8 characters';
//     }
//
//     return null;
//   }
//
//   // Check if form is valid
//   bool _isFormValid(String? emailError,
//       String? passwordError,
//       String email,
//       String password,) {
//     return emailError == null &&
//         passwordError == null &&
//         email.isNotEmpty &&
//         password.isNotEmpty;
//   }
//
//   // Email changed event handler
//   void _onEmailChanged(EmailChanged event, Emitter<SignInState> emit) {
//     final emailError = _validateEmail(event.email);
//     final isValid = _isFormValid(
//       emailError,
//       state.passwordError,
//       event.email,
//       state.password,
//     );
//
//     emit(
//       state.copyWith(
//         email: event.email,
//         emailError: emailError,
//         isFormValid: isValid,
//       ),
//     );
//   }
//
//   // Password changed event handler
//   void _onPasswordChanged(PasswordChanged event, Emitter<SignInState> emit) {
//     final passwordError = _validatePassword(event.password);
//     final isValid = _isFormValid(
//       state.emailError,
//       passwordError,
//       state.email,
//       event.password,
//     );
//
//     emit(
//       state.copyWith(
//         password: event.password,
//         passwordError: passwordError,
//         isFormValid: isValid,
//       ),
//     );
//   }
//
//   // Toggle password visibility
//   void _onTogglePasswordVisibility(TogglePasswordVisibility event,
//       Emitter<SignInState> emit,) {
//     emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
//   }
//
// // Sign in submitted event handler
//   Future<void> _onSignInSubmitted(
//       SignInSubmitted event,
//       Emitter<SignInState> emit,
//       ) async {
//     try {
//       // 1. Validate fields from current state
//       final emailError = _validateEmail(state.email);
//       final passwordError = _validatePassword(state.password);
//
//       if (emailError != null || passwordError != null) {
//         emit(
//           state.copyWith(
//             emailError: emailError,
//             passwordError: passwordError,
//             status: ResponseStatus.failure,
//             errorMessage: 'Please fix the errors before submitting',
//           ),
//         );
//         return;
//       }
//
//       // emit(state.copyWith(status: ResponseStatus.inProgress));
//       emit(state.copyWith(status: ResponseStatus.loading));
//
//       // TODO: Implement actual sign in logic here
//       // Example:
//       // final response = await authRepository.signIn(
//       //   email: state.email,
//       //   password: state.password,
//       // );
//       //
//       // response.fold(
//       //   (failure) {
//       //     ErrorModel error = handleException(failure);
//       //     emit(
//       //       state.copyWith(
//       //         status: ResponseStatus.failure,
//       //         errorMessage: error.message,
//       //       ),
//       //     );
//       //   },
//       //   (data) {
//       //     emit(
//       //       state.copyWith(
//       //         status: ResponseStatus.success,
//       //       ),
//       //     );
//       //   },
//       // );
//
//       // Temporary success for testing
//       await Future.delayed(const Duration(seconds: 2));
//       emit(state.copyWith(status: ResponseStatus.success));
//     } catch (e, s) {
//       logger.e("Sign in error: $e", s);
//       emit(
//         state.copyWith(
//           status: ResponseStatus.failure,
//           errorMessage: e.toString(),
//         ),
//       );
//     }
//   }
// }


import 'package:social_golf_app/core/bloc/base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container_common.dart';
import '../../../../core/network/network_call/domain/repository/auth_repository.dart';
import '../../../../core/shared_pref/preferences_utils.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';
import '../../../../core/utils/constants/enums.dart';

class SignInBloc extends BaseBloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;
  final pref = serviceLocator<PreferencesUtil>();
  SignInBloc({required this.authRepository}) : super(const SignInState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SignInSubmitted>(_onSignInSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
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

  // Check if form is valid
  bool _isFormValid(String? emailError,
      String? passwordError,
      String email,
      String password,) {
    return emailError == null &&
        passwordError == null &&
        email.isNotEmpty &&
        password.isNotEmpty;
  }

  // Email changed event handler
  void _onEmailChanged(EmailChanged event, Emitter<SignInState> emit) {
    final emailError = _validateEmail(event.email);
    final isValid = _isFormValid(
      emailError,
      state.passwordError,
      event.email,
      state.password,
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
  void _onPasswordChanged(PasswordChanged event, Emitter<SignInState> emit) {
    final passwordError = _validatePassword(event.password);
    final isValid = _isFormValid(
      state.emailError,
      passwordError,
      state.email,
      event.password,
    );

    emit(
      state.copyWith(
        password: event.password,
        passwordError: passwordError,
        isFormValid: isValid,
      ),
    );
  }

  // Toggle password visibility
  void _onTogglePasswordVisibility(TogglePasswordVisibility event,
      Emitter<SignInState> emit,) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

// Sign in submitted event handler
  Future<void> _onSignInSubmitted(
      SignInSubmitted event,
      Emitter<SignInState> emit,
      ) async {
    try {
      // 1. Validate fields from current state
      final emailError = _validateEmail(state.email);
      final passwordError = _validatePassword(state.password);

      if (emailError != null || passwordError != null) {
        emit(
          state.copyWith(
            emailError: emailError,
            passwordError: passwordError,
            status: ResponseStatus.failure,
            errorMessage: 'Please fix the errors before submitting',
          ),
        );
        return;
      }

      // 2. Set loading status and clear previous errors
      emit(state.copyWith(
        status: ResponseStatus.loading,
        errorMessage: null,
        serverContact: null,
      ));

      // 4. Call the repository
      final response = await authRepository.login(state.email,state.password);

      // 5. Fold the response (Either<Failure, LoginResponse>)
      await response.fold(
            (failure) async {
          // Handle Exception from BaseBloc
          final errorModel = handleException(failure);
          logger.e('Sign In Error: ${errorModel.message}',null);

          emit(state.copyWith(
            status: ResponseStatus.failure,
            errorMessage: errorModel.message,
          ));
        },
            (r) async {
          // Handle API success/failure based on the JSON "success" boolean
          if (r.success) {
            // Save session to Shared Preferences
            await pref.saveLoginData(r);

            emit(state.copyWith(
              status: ResponseStatus.success,
              serverContact: r, // Pass the response model to state
              errorMessage: r.message,
            ));
          } else {
            // API Logic error (e.g., "Invalid credentials")
            emit(state.copyWith(
              status: ResponseStatus.failure,
              errorMessage: r.message,
            ));
          }
        },
      );
    } catch (e, s) {
      logger.e("Sign in unexpected error: $e", s);
      emit(
        state.copyWith(
          status: ResponseStatus.failure,
          errorMessage: "An unexpected error occurred. Please try again.",
        ),
      );
    }
  }
}