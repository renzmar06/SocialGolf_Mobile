import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailChanged extends SignInEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends SignInEvent {
  final String password;

  PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignInSubmitted extends SignInEvent {
  SignInSubmitted();

  @override
  List<Object?> get props => [];
}

class TogglePasswordVisibility extends SignInEvent {
  TogglePasswordVisibility();

  @override
  List<Object?> get props => [];
}
