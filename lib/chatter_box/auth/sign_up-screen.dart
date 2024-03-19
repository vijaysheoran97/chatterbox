import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {

    TextEditingController userPassword = TextEditingController();
    bool _isPasswordVisible = false;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 120),
            Center(
              child: Container(
                child: Image.asset('assets/images/chat1.png'),
                height: 160,
                width: 160,
              ),
            ),
            const SizedBox(height: 80),
            // Email TextField
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              width: 400,
              child: TextFormField(
                controller: TextEditingController(),
                cursorColor: AppColorConstant.appText2Color,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: AppStringConstant.email,
                  prefixIcon: const Icon(Icons.email_outlined),
                  contentPadding: const EdgeInsets.only(top: 2, left: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Password TextField
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              width: 400,
              child: TextFormField(
                controller: userPassword,
                cursorColor: AppColorConstant.appText2Color,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: AppStringConstant.password,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.only(top: 2, left: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            // Password TextField
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              width: 400,
              child: TextFormField(
                controller: userPassword,
                cursorColor: AppColorConstant.appText2Color,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  hintText: AppStringConstant.confirmPassword,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.only(top: 2, left: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            // Login Button
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 28),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(AppColorConstant.buttonColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: Text(
                    AppStringConstant.signUp11,
                    style: const TextStyle(fontSize: 20, color: AppColorConstant.buttonText),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Sign Up Link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppStringConstant.alreadyHaveAnAccount),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return const SignUpScreen();
                    }));
                  },
                  child: Text(
                    AppStringConstant.login,
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
