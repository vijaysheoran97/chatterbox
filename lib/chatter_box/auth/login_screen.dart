// import 'package:chatterbox/chatter_box/auth/sign_up-screen.dart';
// import 'package:chatterbox/chatter_box/dialogbox/forget_password_dialog.dart';
// import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
// import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
// import 'package:flutter/material.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController userPassword = TextEditingController();
//   bool _isPasswordVisible = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 120),
//             Center(
//               child: Container(
//                 child: Image.asset('assets/images/chat1.png'),
//                 height: 160,
//                 width: 160,
//               ),
//             ),
//             const SizedBox(height: 80),
//             // Email TextField
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 5.0),
//               width: 400,
//               child: TextFormField(
//                 controller: TextEditingController(),
//                 cursorColor: AppColorConstant.appText2Color,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   hintText: AppStringConstant.email,
//                   prefixIcon: const Icon(Icons.email_outlined),
//                   contentPadding: const EdgeInsets.only(top: 2, left: 8),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Password TextField
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 5.0),
//               width: 400,
//               child: TextFormField(
//                 controller: userPassword,
//                 cursorColor: AppColorConstant.appText2Color,
//                 keyboardType: TextInputType.visiblePassword,
//                 obscureText: !_isPasswordVisible,
//                 decoration: InputDecoration(
//                   hintText: AppStringConstant.password,
//                   prefixIcon: const Icon(Icons.lock_outline),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                   contentPadding: const EdgeInsets.only(top: 2, left: 8),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Forget Password Button
//             GestureDetector(
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) => ForgetPasswordDialog(),
//                 );
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     AppStringConstant.forgetPassword,
//                     style: TextStyle(color: AppColorConstant.forgetpassword),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 32),
//             // Login Button
//             Padding(
//               padding: const EdgeInsets.only(left: 28, right: 28),
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor:
//                     MaterialStateProperty.all(AppColorConstant.buttonColor),
//                     shape: MaterialStateProperty.all(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const SignUpScreen()),
//                     );
//                   },
//                   child: Text(
//                     AppStringConstant.login1,
//                     style: const TextStyle(fontSize: 20, color: AppColorConstant.buttonText),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 80),
//             // Sign Up Link
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(AppStringConstant.donotHaveAnAccount),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context) {
//                       return const SignUpScreen();
//                     }));
//                   },
//                   child: Text(
//                     AppStringConstant.signUp,
//                     style: const TextStyle(
//                       color: AppColorConstant.signup,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:chatterbox/chatter_box/auth/email_login_screen.dart';
import 'package:chatterbox/chatter_box/auth/sign_up-screen.dart';
import 'package:chatterbox/chatter_box/screens/homeScreen.dart';
import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
import 'package:flutter/material.dart';

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
            const SizedBox(height: 32,),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: AppColorConstant.buttonColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                onPressed: () async{
                  await AuthService().gmailLogin();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
                icon: Image.asset('assets/images/search1.png'),
                label: Text(
                  AppStringConstant.signUpWithGoogle,
                  style: const TextStyle(color: AppColorConstant.buttonText),
                ),
              ),
            ),
            const SizedBox(height: 32,),
            Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: AppColorConstant.buttonColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                onPressed: () {

                },
                icon: Image.asset('assets/images/apple3.png'),
                label: Text(
                  AppStringConstant.signUpWithApple,
                  style: const TextStyle(color: AppColorConstant.buttonText),
                ),
              ),
            ),
            const SizedBox(height: 32,),
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
                      MaterialPageRoute(builder: (context) => const EmailLoginScreen()));

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
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
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
