import 'dart:convert';

import 'package:ejara/app/entities/user_entry.dart';
import 'package:ejara/app/entities/utils/response_entity.dart';

import "../../../core/core.dart";
import 'package:http/http.dart' as http;

/*
 * @Author Champlain Marius Bakop
 * @email champlainmarius20@gmail.com
 * @github ChamplainLeCode
 * 
 */
@Controller
class HomeController {
  dynamic index() {
    screen("home", RouteMode.REPLACE);
  }

  Future<ResponseEntity<String>> validateInput(UserEntry data) async {
    http.Response r = await http.post(
        'https://sandbox.nellys-coin.ejaraapis.xyz/api/v1/auth/sign-up/check-signup-details',
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': data.username,
          'email_address': data.email,
          'phone_number': data.phone,
          'country_code': data.countryCode
        }));
    print(r.body);
    print(r.headers);
    switch (r.statusCode) {
      case 200:
        return ResponseEntity<String>.done('Welcome on Ejara world');
        break;
      case 404:
        if (r.headers['x-exit'] == 'invalidEmail') {
          return ResponseEntity.fail('Your email address is not valid');
        }

        if (r.headers['x-exit'] == 'usernameAlreadyInUse') {
          return ResponseEntity.fail('Your username is already in use');
        }

        return ResponseEntity.fail('Please contact an admin for assistance');
      case 400:
        if (r.headers['x-exit'] == 'invalidPhoneNumber') {
          return ResponseEntity.fail('Your phone is invalid');
        }
        return ResponseEntity.fail('Please contact an admin for assistance');
      case 409:
        if (r.headers['x-exit'] == 'emailAlreadyInUse') {
          return ResponseEntity.fail('Your email address is already in use');
        }

        if (r.headers['x-exit'] == 'phoneAlreadyInUse') {
          return ResponseEntity.fail('Your phone number is already in use');
        }

        if (r.headers['x-exit'] == 'usernameUnavailable') {
          return ResponseEntity.fail('Username not allowed');
        }
        return ResponseEntity.fail('Please contact an admin for assistance');
      case 500:
        return ResponseEntity.fail('Please contact an admin for assistance');
    }
    return null;
//    return response?.remove('valid') ?? false;
  }
}
