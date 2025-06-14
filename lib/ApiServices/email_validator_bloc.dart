import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:email_checker/Utils/Constants.dart';
import 'package:meta/meta.dart';

part 'email_validator_event.dart';
part 'email_validator_state.dart';

class EmailValidatorBloc extends Bloc<EmailValidatorEvent, EmailValidatorState> {
  EmailValidatorBloc() : super(EmailValidatorInitial()) {
    on<EmailValidatorEmailHandler>((event, emit) async {
      emit(EmailValidatorLoadingState());
      try {
        String url = "${ApiConstants.baseUrl}?email=${event.email}";

        developer.log(url);

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Avatar-Key': ApiConstants.xAvatarKey,
          },
        );

        developer.log('response body: ${response.body}');
        developer.log('response statusCode: ${response.statusCode}');

        if(response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          final isExist = (responseData['is_exist']?.toString().toLowerCase() == "true");

          if (isExist) {
            emit(EmailValidatorSuccessState("✅ The email address exists.", responseData: responseData));
          } else {
            emit(EmailValidatorErrorState("❌ The email address does not exist."));
          }
        }
        else if(response.statusCode == 404 || response.statusCode == 400) {
          final responseData = jsonDecode(response.body);
          String responseMessage = responseData['message'];
          emit(EmailValidatorErrorState(responseMessage));
        } else if(response.statusCode >= 500) {
          emit(EmailValidatorGatewayError());
        }
      } catch(e) {
        developer.log('catch error: $e');
        emit(EmailValidatorErrorState('Something went wrong. Please try again later.'));
      }
    });
  }
}
