//import 'package:intl_phone_field/phone_number.dart';

bool isEmailValid({required String email}) {
  return RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  ).hasMatch( email );
}

bool isPasswordValid({required String password}) {
  final regex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$',
  );
  return regex.hasMatch( password );
}

//PHONE NUMBER VALIDATION
// bool isPhoneNumberValid({required String number}) {
//   PhoneNumber? phoneNumber = PhoneNumber.fromCompleteNumber(
//     completeNumber: number,
//   );
//   if (phoneNumber == null || phoneNumber.number.isEmpty) {
//     return false;
//   }
//   try {
//     if (phoneNumber.isValidNumber()) {
//       return true;
//     }
//   } catch (e) {
//     return false;
//   }
//   return false;
// }