// import 'dart:convert';

// import 'package:first_app/Pages/EditProfile.dart';
// import 'package:first_app/Pages/LoginPage.dart';
// import 'package:first_app/main.dart';
// import 'package:first_app/models/user.dart';
// import 'package:first_app/widgets/showtoast.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';

// class UpdateProfile {
//   final String email;
//   final String fname;
//   final String lname;
//   final String phone;
//   final String birthdate;

//   final String ip = MyApp.ipv4;
//   // UpdateProfile(this.email, this.pass);

//   void signup(BuildContext context) {}

//   void showSnackbar(
//     BuildContext context,
//     String message,
//   ) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
// }

// String getEmailPrefix(String email) {
//   return email.split('@')[0];
// }

// Future<User?> SignupforUser(
//     String email, String password, BuildContext context, String ip) async {
//   final url = Uri.parse("$ip/v1/users");
//   Map<String, String> headers = {
//     'Content-Type': 'application/json',
//   };
//   String username = getEmailPrefix(email);
//   Map<String, dynamic> request = {
//     "username": username,
//     "password": password,
//     "firstname": "",
//     "lastname": "",
//     "birthdate": "",
//     "email": email,
//     "phone": "",
//     "avatarImg": "",
//   };

//   if (email.isEmpty || password.isEmpty) {
//     throw Exception('Email or password cannot be empty');
//   }
//   print("Request body: $request");
//   try {
//     final response = await http.post(
//       url,
//       headers: headers,
//       body: json.encode(request),
//     );

//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonResponse = json.decode(response.body);
//       String message = jsonResponse['message'] ?? 'Success';
//       print("Success: $message");

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ProfilePage(
//             username: username,
//             email: email,
//           ),
//         ),
//       );
//     } else if (response.statusCode == 400) {
//       Map<String, dynamic> jsonResponse = json.decode(response.body);
//       String errorMessage = jsonResponse['message'] ?? 'Not found';
//       showErrorToast(errorMessage);
//       return Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     } else if (response.statusCode == 404) {
//       Map<String, dynamic> jsonResponse = json.decode(response.body);
//       String errorMessage = jsonResponse['message'] ?? 'Not found';
//       showErrorToast(errorMessage);
//       return Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => LoginPage()),
//       );
//     } else {
//       print("Error ${response.statusCode}: ${response.body}");
//       throw Exception("Request failed with status: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Request failed: $e");
//     throw Exception("Request failed: $e");
//   }

//   return null;
// }
