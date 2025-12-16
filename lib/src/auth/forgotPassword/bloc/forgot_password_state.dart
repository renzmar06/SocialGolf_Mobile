import 'package:equatable/equatable.dart';
import '../../../../core/utils/constants/enums.dart';

class ForgotPasswordState extends Equatable {
  final String email;
  final String? emailError;
  final bool isFormValid;
  final ResponseStatus status;
  final String? errorMessage;
  final String? successMessage;

  const ForgotPasswordState({
    this.email = '',
    this.emailError,
    this.isFormValid = false,
    this.status = ResponseStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  ForgotPasswordState copyWith({
    String? email,
    String? emailError,
    bool? isFormValid,
    ResponseStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailError: emailError,
      isFormValid: isFormValid ?? this.isFormValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
    email,
    emailError,
    isFormValid,
    status,
    errorMessage,
    successMessage,
  ];
}
