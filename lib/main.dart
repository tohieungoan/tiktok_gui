import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/CreateProfilePage.dart';
import 'Pages/SignupPage.dart';
import 'firebase_options.dart';
import 'Pages/LoginPage.dart';
import 'package:first_app/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "tiktok-first", options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String ipv4 = "http://192.168.114.140:8000";
  const MyApp({super.key});

  page() {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      print("Logged in");
      return LoginPage();
    } else {
      return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tiktok',
        theme: ThemeData(
          fontFamily: 'Poppins',
          primarySwatch: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        home: page());
  }
}
