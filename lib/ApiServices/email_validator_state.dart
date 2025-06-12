part of 'email_validator_bloc.dart';

@immutable
sealed class EmailValidatorState {}

final class EmailValidatorInitial extends EmailValidatorState {}

class EmailValidatorLoadingState extends EmailValidatorState {}

class EmailValidatorSuccessState extends EmailValidatorState {
  bool response;
  EmailValidatorSuccessState(this.response);
}

class EmailValidatorErrorState extends EmailValidatorState {
  String errorMessage;
  EmailValidatorErrorState(this.errorMessage);
}
