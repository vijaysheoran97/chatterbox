import 'package:chatterbox/chatter_box/auth/email_login_screen.dart';
import 'package:chatterbox/chatter_box/auth/sign_up-screen.dart';
import 'package:chatterbox/chatter_box/screens/homeScreen.dart';
import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 120),
            Center(
              child: Container(
                child: Image.asset("assets/images/chat1.png"),
                height: 160,
                width: 160,
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: AppColorConstant.buttonColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                onPressed: () async {
                  await AuthService().gmailLogin();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                },
                icon: Image.asset('assets/images/search1.png'),
                label: Text(
                  AppStringConstant.signUpWithGoogle,
                  style: const TextStyle(color: AppColorConstant.buttonText),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: AppColorConstant.buttonColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/images/apple3.png'),
                label: Text(
                  AppStringConstant.signUpWithApple,
                  style: const TextStyle(color: AppColorConstant.buttonText),
                ),
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: AppColorConstant.buttonColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmailLoginScreen()));
                },
                icon: Image.asset('assets/images/gmail2.png'),
                label: Text(
                  AppStringConstant.signUpWithEmail,
                  style: const TextStyle(color: AppColorConstant.buttonText),
                ),
              ),
            ),
            const SizedBox(height: 80),
            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStringConstant.donotHaveAnAccount),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: Text(
                    AppStringConstant.signUp,
                    style: const TextStyle(
                      color: AppColorConstant.signup,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
