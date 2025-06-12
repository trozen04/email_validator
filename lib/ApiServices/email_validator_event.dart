part of 'email_validator_bloc.dart';

@immutable
sealed class EmailValidatorEvent {}

class EmailValidatorEmailHandler extends EmailValidatorEvent{
  String email;
  EmailValidatorEmailHandler({required this.email});
}
