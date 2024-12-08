import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RESETpasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RESETpassword();
}

class _RESETpassword extends State<RESETpasswordPage> {
  @override
  var email = TextEditingController();

  reset_password() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email.text.toString());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.35,
                child: Image.asset('assets/images/reset_pass.webp'),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Quên \nMật khẩu?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 35,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Đừng lo lắng! Vui lòng nhập \nđịa chỉ liên kết với tài khoản..",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                alignment: Alignment.centerRight,
                child: Form(
                  child: TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.alternate_email_rounded,
                          color: Colors.grey),
                      hintText: "Nhập vào địa chỉ email của bạn",
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              ElevatedButton(
                onPressed: () {
                  reset_password();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(screenHeight * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Reset",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
