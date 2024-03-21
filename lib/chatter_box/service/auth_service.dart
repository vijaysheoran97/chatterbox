import 'package:chatterbox/model/user_info_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final auth = FirebaseAuth.instance;
  final googleLogin = GoogleSignIn();

  gmailLogin() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleLogin.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential authCre = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        await auth.signInWithCredential(authCre);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  logOut() async {
    await auth.signOut();
    await googleLogin.signOut();
  }






  Future createAccount(UserModel userModel)async{
  final  credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email:userModel .email,
  password:userModel. password,
  );
  if (kDebugMode) {
  print('Account created');
  }


  }
  Future login(UserModel userModel)async{
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: userModel.email,
  password: userModel.password,
  );

  }
  Future logout()async{
  await FirebaseAuth.instance.signOut();
  }
  }
