import 'package:equatable/equatable.dart';
import '../../../../core/network/network_call/data/model/login_response.dart';
import '../../../../core/utils/constants/enums.dart';

class SignInState extends Equatable {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isPasswordVisible;
  final bool isFormValid;
  final ResponseStatus status;
  final String? errorMessage;
  final LoginResponse? serverContact;

  const SignInState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isPasswordVisible = false,
    this.isFormValid = false,
    this.status = ResponseStatus.initial,
    this.errorMessage,
    this.serverContact,
  });

  SignInState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isPasswordVisible,
    bool? isFormValid,
    ResponseStatus? status,
    String? errorMessage,
    LoginResponse? serverContact,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isFormValid: isFormValid ?? this.isFormValid,
      status: status ?? this.status,
      errorMessage: errorMessage,
      serverContact: serverContact ?? this.serverContact,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    emailError,
    passwordError,
    isPasswordVisible,
    isFormValid,
    status,
    errorMessage,
    serverContact,
  ];
}
