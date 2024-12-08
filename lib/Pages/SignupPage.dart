import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:first_app/call_api_controller/signup.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  String email = '';
  String pass = '';

  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);

  var id = TextEditingController();
  var password = TextEditingController();

  void passwordVisibility() {
    if (notVisiblePassword) {
      passwordIcon = const Icon(Icons.visibility);
    } else {
      passwordIcon = const Icon(Icons.visibility_off);
    }
  }

  void sendVerificationEmail() {
    User user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification();
  }

  create_user() {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: id.text.toString().trim(),
            password: password.text.toString().trim())
        .whenComplete(() {
      if (FirebaseAuth.instance.currentUser?.uid != null) {
        sendVerificationEmail();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Verification mail has been sent to registered Email ID. Verify your account and login again.')));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      }
    });
  }

  void showPolicyPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Điều khoản & Chính sách',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Điều khoản và điều kiện:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("- Bạn đồng ý tuân thủ các quy định của chúng tôi.\n"
                    "- Không sử dụng dịch vụ vào mục đích bất hợp pháp."),
                SizedBox(height: 16),
                Text(
                  "Chính sách bảo mật:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("- Chúng tôi cam kết bảo vệ dữ liệu cá nhân của bạn.\n"
                    "- Thông tin của bạn chỉ được sử dụng theo mục đích hợp pháp."),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Topmost image
            Container(
              height: size.height / 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  'assets/images/signup.jpg',
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Column(
                children: [
                  // Login Text
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Đăng ký',
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  // Sized box
                  const SizedBox(height: 10),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.alternate_email_outlined,
                              color: Colors.grey,
                            ),
                            labelText: 'Email ID',
                          ),
                          controller: id,
                        ),
                        TextFormField(
                          obscureText: notvisible,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.grey,
                            ),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  notvisible = !notvisible;
                                  notVisiblePassword = !notVisiblePassword;
                                  passwordVisibility();
                                });
                              },
                              icon: passwordIcon,
                            ),
                          ),
                          controller: password,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 13),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: showPolicyPopup,
                            child: const Text(
                              'Bằng cách đăng ký, bạn đồng ý với Điều khoản & điều kiện và Chính sách bảo mật của chúng tôi',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                          ),
                          onPressed: showPolicyPopup,
                          tooltip: 'Xem chính sách',
                        ),
                      ],
                    ),
                  ),

                  // SignUp Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        email = id.text.trim();
                        pass = password.text.trim();
                      });
                      final signupApi = SignupApi(email, pass);
                      signupApi.signup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Đã có tài khoản? ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Đăng nhập",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginPage();
                            }));
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
