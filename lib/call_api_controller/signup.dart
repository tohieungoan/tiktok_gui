import 'dart:convert';

import 'package:first_app/Pages/EditProfile.dart';
import 'package:first_app/Pages/LoginPage.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/widgets/showtoast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SignupApi {
  final String email;
  final String pass;
  final String ip = MyApp.ipv4;
  SignupApi(this.email, this.pass);

  void signup(BuildContext context) {
    if (!validateEmail(email)) {
      showSnackbar(context, "Email không hợp lệ");
      return;
    }
    if (!validatePassword(pass)) {
      showSnackbar(context, "Mật khẩu phải có ít nhất 6 ký tự");
      return;
    }
    SignupforUser(email, pass, context, ip);
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w\.\-]+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$');
    return emailRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  void showSnackbar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

String getEmailPrefix(String email) {
  return email.split('@')[0];
}

Future<User?> SignupforUser(
    String email, String password, BuildContext context, String ip) async {
  final url = Uri.parse("$ip/users");
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };
  String username = getEmailPrefix(email);
  Map<String, dynamic> request = {
    "username": username,
    "password": password,
    "firstname": "",
    "lastname": "",
    "birthdate": "",
    "email": email,
    "phone": "",
  };
      // "avatarImg": "",

  if (email.isEmpty || password.isEmpty) {
    throw Exception('Email or password cannot be empty');
  }
  print("Request body: $request");
  try {
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(request),
    );

    if (response.statusCode == 200) {
      // Giải mã JSON từ body của response
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      String message = jsonResponse['message'] ?? 'Success';
      print("Success: $message");

      var result = jsonResponse['result'];
      print(result);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ProfilePage(
      //       username: username,
      //       email: email,
      //       id: result,
      //     ),
      //   ),
      // );
    } else if (response.statusCode == 400) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String errorMessage = jsonResponse['message'] ?? 'Not found';
      showErrorToast(errorMessage);
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else if (response.statusCode == 404) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      String errorMessage = jsonResponse['message'] ?? 'Not found';
      showErrorToast(errorMessage);
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      print("Error ${response.statusCode}: ${response.body}");
      throw Exception("Request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("Request failed: $e");
    throw Exception("Request failed: $e");
  }

  return null;
}
