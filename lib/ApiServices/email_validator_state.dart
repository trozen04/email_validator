part of 'email_validator_bloc.dart';

@immutable
sealed class EmailValidatorState {}

final class EmailValidatorInitial extends EmailValidatorState {}

class EmailValidatorLoadingState extends EmailValidatorState {}

class EmailValidatorSuccessState extends EmailValidatorState {
  String response;
  final responseData;
  EmailValidatorSuccessState(this.response, {required this.responseData});
}

class EmailValidatorErrorState extends EmailValidatorState {
  String errorMessage;
  EmailValidatorErrorState(this.errorMessage);
}

class EmailValidatorGatewayError extends EmailValidatorState {

}
