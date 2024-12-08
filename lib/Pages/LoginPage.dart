import 'package:first_app/Services/reset_password.dart';
import 'package:first_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:first_app/Services/otp_page.dart';
import 'SignupPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
// =========================================Declaring are the required variables=============================================
  final _formKey = GlobalKey<FormState>();

  var id = TextEditingController();
  var password = TextEditingController();

  bool notvisible = true;
  bool notVisiblePassword = true;
  Icon passwordIcon = const Icon(Icons.visibility);
  bool emailFormVisibility = true;
  bool otpVisibilty = false;

  String? emailError;
  String? passError;
  String? _verificationCode;

// ================================================Password Visibility function ===========================================

  void passwordVisibility() {
    if (notVisiblePassword) {
      passwordIcon = const Icon(Icons.visibility);
    } else {
      passwordIcon = const Icon(Icons.visibility_off);
    }
  }

// ================================================Login Function ======================================================
  login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: id.text.toString(), password: password.text.toString());
      isEmailVerified();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        emailError = 'Enter valid email ID';
      }
      if (e.code == 'wrong-password') {
        passError = 'Enter correct password';
      }
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You are not registed. Sign Up now")));
      }
    }
    setState(() {});
  }

// ================================================Login Using Google function ==============================================

  signInWithGoogle() async {
    // Yêu cầu người dùng đăng nhập với Google
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Lấy thông tin tài khoản Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Lấy thông tin từ tài khoản Google
      String displayName = googleUser.displayName ?? 'No display name';
      String email = googleUser.email ?? 'No email';
      String? photoUrl = googleUser.photoUrl;

      // Hiển thị thông tin tài khoản Google (bạn có thể sử dụng showDialog, hoặc update UI trực tiếp)
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Google Account Info'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $displayName'),
                Text('Email: $email'),
                if (photoUrl != null) Image.network(photoUrl),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } else {
      // Người dùng không đăng nhập thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed')),
      );
    }
  }

// ================================================= Checking if email is verified =======================================

  void isEmailVerified() {
    User user = FirebaseAuth.instance.currentUser!;
    if (user.emailVerified) {
      first_login();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email is not verified.')));
    }
  }

// ================================================= Checking First time login ===============================================

  first_login() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Kiểm tra nếu user không phải là null
      DateTime? creation = user.metadata.creationTime;
      DateTime? lastlogin = user.metadata.lastSignInTime;

      if (creation == lastlogin) {
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) {
        //   return CreateProfilePage();
        // }));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    } else {
      // Trường hợp người dùng chưa đăng nhập
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user is logged in')),
      );
    }
  }

// ================================================Building The Screen ===================================================
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05), // Khoảng cách phía trên
            // Ảnh trên cùng
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Image.asset(
                'assets/images/login1.webp',
                width: screenWidth * 0.8, // Độ rộng phù hợp màn hình
              ),
            ),
            SizedBox(
                height:
                    screenHeight * 0.02), // Khoảng cách giữa ảnh và nội dung
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.07, // Khoảng cách ngang
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tiêu đề "Login"
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Form Email
                  Visibility(
                    visible: emailFormVisibility,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email
                          TextFormField(
                            decoration: InputDecoration(
                              icon: const Icon(Icons.alternate_email_outlined),
                              labelText: 'Email ID',
                            ),
                            controller: id,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Password
                          TextFormField(
                            obscureText: notvisible,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock_outline_rounded),
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
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.indigo,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return RESETpasswordPage();
                        }));
                      },
                    ),
                  ),
                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      if (emailFormVisibility) {
                        login();
                        first_login();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(screenHeight * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Đăng nhập",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // OR Divider
                  Stack(
                    children: [
                      const Divider(thickness: 1),
                      Center(
                        child: Container(
                          color: Colors.white,
                          width: screenWidth * 0.2,
                          child: const Center(
                            child: Text(
                              "Hoặc",
                              style: TextStyle(
                                fontSize: 20,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Login with Google
                  ElevatedButton.icon(
                    onPressed: () {
                      signInWithGoogle();
                      first_login();
                    },
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      width: screenWidth * 0.05,
                      height: screenHeight * 0.05,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(screenHeight * 0.06),
                      backgroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    label: const Center(
                      child: Text(
                        "Đăng nhập với Google",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  // Register Section
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Người dùng mới? ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          child: const Text(
                            "Đăng ký ngay",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return SignUpPage();
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
