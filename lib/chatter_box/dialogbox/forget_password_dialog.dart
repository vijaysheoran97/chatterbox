
import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
import 'package:flutter/material.dart';

class ForgetPasswordDialog extends StatelessWidget {
  final TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStringConstant.forgetPassword),
      content: TextField(
        controller: userEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(hintText: 'Enter your email'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Implement logic to reset password
            // You can access entered email via userEmail.text
            // For example:
            // String email = userEmail.text;
            // Implement logic to reset password using this email
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Reset Password'),
        ),
      ],
    );
  }
}