

import 'package:chatterbox/chatter_box/auth/otp_screen.dart';
import 'package:chatterbox/chatter_box/screens/homeScreen.dart';
import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GoogleLoginScreen extends StatefulWidget {


  const GoogleLoginScreen({super.key});

  @override
  State<GoogleLoginScreen> createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  TextEditingController phoneController = TextEditingController();
  var phone = '';

  @override
  void initState() {
    phoneController.text = '+91';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
        const EdgeInsets.only(top: 80, bottom: 100, left: 20, right: 20),
        child: Column(
          children: [
            Image.asset("assets/images/phone.png"),
            const Spacer(),
            const Text(
              "Phone Verification",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "We need to register your before getting started !",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: phoneController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Input your phone no',
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Divider(
                endIndent: 60, indent: 60, color: Colors.black, height: 46),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // await phoneLogin(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.green.shade600,
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sign in with '),
                GestureDetector(
                    onTap: () async {
                      await AuthService().gmailLogin();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                      Fluttertoast.showToast(
                          msg: 'Account Create Successfully');
                    },

                    child: Image.network(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvxBezs9OPFPeToUu8mj4b7lTwtBwZA1WaFg&usqp=CAU",
                      height: 80,
                      width: 80,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> phoneLogin(BuildContext context) async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phoneController.text + phone,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {},
  //     codeSent: (String verificationId, int? resendToken) {
  //       GoogleLoginScreen.verify = verificationId;
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) {
  //           return const OtpScreen();
  //         }),
  //       );
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  // }
}