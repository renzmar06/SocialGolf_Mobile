import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailChanged extends SignUpEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignUpEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class ConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;

  ConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class SignUpSubmitted extends SignUpEvent {
  SignUpSubmitted();

  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibility extends SignUpEvent {
  TogglePasswordVisibility();

  @override
  List<Object?> get props => [];
}

class ToggleConfirmPasswordVisibility extends SignUpEvent {
  ToggleConfirmPasswordVisibility();

  @override
  List<Object?> get props => [];
}
