import 'dart:convert';

import 'package:first_app/Pages/CreateProfilePage.dart';
import 'package:first_app/Pages/LoginPage.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

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

Future<User?> SignupforUser(
    String email, String password, BuildContext context, String ip) async {
  final url = Uri.parse("$ip/api/signup");
  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  Map<String, dynamic> request = {
    "email": email,
    "password": password,
  };

  final response = await http.post(
    url,
    headers: headers,
    body: json.encode(request),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    String Messagec = jsonResponse['message'];
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CreateProfilePage()),
    );
  } else if (response.statusCode == 404) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    String errorMessage = jsonResponse['message'];
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } else {
    throw Exception("failed");
  }
}
