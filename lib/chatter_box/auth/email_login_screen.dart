// import 'package:chatterbox/chatter_box/auth/sign_up-screen.dart';
// import 'package:chatterbox/chatter_box/dialogbox/forget_password_dialog.dart';
// import 'package:chatterbox/chatter_box/provider/auth_provider.dart';
// import 'package:chatterbox/chatter_box/screens/homeScreen.dart';
// import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
// import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
// import 'package:chatterbox/model/user_info_model.dart';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class EmailLoginScreen extends StatefulWidget {
//   const EmailLoginScreen({super.key});
//
//   @override
//   State<EmailLoginScreen> createState() => _EmailLoginScreenState();
// }
//
// class _EmailLoginScreenState extends State<EmailLoginScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//
//   bool _isPasswordVisible = false;
//   @override
//   Widget build(BuildContext context) {
//
//
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body:
//       Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 120),
//               Center(
//                 child: Container(
//                   child: Image.asset('assets/images/chat1.png'),
//                   height: 160,
//                   width: 160,
//                 ),
//               ),
//               const SizedBox(height: 80),
//               // Email TextField
//               TextFormField(
//                 controller: emailController,
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
//               const SizedBox(height: 24),
//               // Password TextField
//               TextFormField(
//                 controller: passwordController,
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
//               const SizedBox(height: 16),
//               // Forget Password Button
//               GestureDetector(
//                 onTap: () {
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) => ForgetPasswordDialog(),
//                   );
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       AppStringConstant.forgetPassword,
//                       style: const TextStyle(color: AppColorConstant.forgetpassword),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),
//               // Login Button
//               Padding(
//                 padding: const EdgeInsets.only(left: 28, right: 28),
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor:
//                       MaterialStateProperty.all(AppColorConstant.buttonColor),
//                       shape: MaterialStateProperty.all(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                     onPressed: ()async {
//                       if (formKey.currentState!.validate()) {
//                         login();
//                       }
//                                        },
//                     child: Text(
//                       AppStringConstant.login1,
//                       style: const TextStyle(fontSize: 20, color: AppColorConstant.buttonText),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 80),
//               // Sign Up Link
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(AppStringConstant.donotHaveAnAccount),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.push(context, MaterialPageRoute(builder: (context) {
//                         return  SignUpScreen();
//                       }));
//                     },
//                     child: Text(
//                       AppStringConstant.signUp,
//                       style: const TextStyle(
//                         color: AppColorConstant.signup,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//
//     );
//   }
//

import 'package:chatterbox/chatter_box/auth/sign_up-screen.dart';
import 'package:chatterbox/chatter_box/dialogbox/forget_password_dialog.dart';
import 'package:chatterbox/chatter_box/provider/auth_provider.dart';
import 'package:chatterbox/chatter_box/screens/homeScreen.dart';
import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
import 'package:chatterbox/model/user_info_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<AuthProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: SizedBox(
                        height: 160,
                        width: 160,
                        child: Image.asset('assets/images/chat1.png'),
                      ),
                    ),
                    const SizedBox(height: 80),
                    TextFormField(
                      controller: emailController,
                      cursorColor: AppColorConstant.appText2Color,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppStringConstant.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                        contentPadding: const EdgeInsets.only(top: 2, left: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: passwordController,
                      cursorColor: AppColorConstant.appText2Color,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: AppStringConstant.password,
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    const SizedBox(height: 16),

                    // Forget Password Button
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              ForgetPasswordDialog(),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            AppStringConstant.forgetPassword,
                            style: const TextStyle(
                                color: AppColorConstant.forgetpassword),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Login Button
                    Padding(
                        padding: const EdgeInsets.only(left: 28, right: 28),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColorConstant.buttonColor),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                login();
                              }
                            },
                            child: Text(
                              AppStringConstant.login1,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: AppColorConstant.buttonText),
                            ),
                          ),
                        )),

                    const SizedBox(height: 80),
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStringConstant.donotHaveAnAccount),
                        GestureDetector(
                          onTap: () {
                            openSignUpScreen(context);
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
          },
        ),
      ),
      //   ],
      // ),
    );
  }

  void openSignUpScreen(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const SignUpScreen();
    }));
  }

  Future login() async {
    UserModel userModel = UserModel(
      email: emailController.text,
      password: passwordController.text,
    );

    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);

    bool loginSuccessful = await provider.login(userModel);
    //
        if( loginSuccessful ){

          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed. Incorrect email or password.'),
            ),
          );
        }
  }
}
