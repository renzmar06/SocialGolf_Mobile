import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailChanged extends ForgotPasswordEvent {
  final String email;

  EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class ResetPasswordSubmitted extends ForgotPasswordEvent {
  ResetPasswordSubmitted();

  @override
  List<Object?> get props => [];
}
