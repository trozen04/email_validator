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

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
            'X-Avatar-Key': ApiConstants.xAvatarKey,
          },
        );

        developer.log('response body: ${response.body}');

        if(response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          emit(EmailValidatorSuccessState(true));
        } else {
          emit(EmailValidatorErrorState('errorMessage'));
        }

      } catch(e) {
        developer.log('catch error: $e');

      }
    });
  }
}
