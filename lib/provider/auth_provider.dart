


import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:chatterbox/chatter_box/utils/storage_halper.dart';
import 'package:chatterbox/model/user_info_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UserProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isError =false;
  bool  isLoggedIn =false;

  Future createAccount(UserModel userModel) async {
    try {
      isError =false;
      isLoading = true;
      notifyListeners();
      AuthService authService = Get.find();
      await authService.createAccount(userModel);
      isLoading = false;
      notifyListeners();
    }

    on FirebaseAuthException catch (e) {
      isLoading=false;
      isError =true;
      notifyListeners();
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg:'The password provided is too weak.' );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg:'The account already exists for that email.' );
      }
      else{
        Fluttertoast.showToast(msg: 'Auth Error:${e.code}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
  Future login( UserModel userModel)async{
    try{
      isError =false;
      isLoading =true;
      notifyListeners();
      AuthService authService = Get.find();
      await  authService.login(userModel);
      StorageHalper storageHelper =Get.find();
      storageHelper. saveLoginStatus();
      isLoading =false;
      notifyListeners();
    }
    on FirebaseAuthException catch (e) {
      isLoading =false;
      isError =true;
      notifyListeners();
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email.');

      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');

      }
      else{
        Fluttertoast.showToast(msg: 'Auth Error:${e.code}');
      }
    }}
  Future logout()async{
    try {
      isError =false;
      isLoading =true;
      notifyListeners();
      AuthService authService = Get.find();
      await authService.logout();
      StorageHalper storageHelper =Get.find();
      storageHelper.removeLoginStatus();
      isLoading=false;
      notifyListeners();
    }
    catch(e){
      isLoading =false;
      isError=true;
      notifyListeners();
    }
  }
  Future loadLoginStatus()async{
    StorageHalper storageHalper  =Get.find();
    isLoggedIn= await storageHalper.getLoginStatus();
    notifyListeners();
  }
}