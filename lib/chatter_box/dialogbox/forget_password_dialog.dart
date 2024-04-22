import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
import 'package:flutter/material.dart';

class ForgetPasswordDialog extends StatelessWidget {
  final TextEditingController userEmail = TextEditingController();
  Future<void> resetPassword(String email) async {
    await AuthService().auth.sendPasswordResetEmail(email: email);
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStringConstant.forgetPassword),
      content: TextField(
        controller: userEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: 'Enter your email'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            resetPassword(userEmail.text);
            Navigator.of(context).pop();
          },
          child: const Text('Reset Password'),
        ),
      ],
    );
  }
}