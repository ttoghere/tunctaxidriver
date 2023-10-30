// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tunctaxidriver/global/global.dart';
import 'package:tunctaxidriver/screens/splash/splash_screen.dart';
import 'package:tunctaxidriver/widgets/progress_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends ChangeNotifier {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController sUNameTextEditingController = TextEditingController();
  TextEditingController sUEmailTextEditingController = TextEditingController();
  TextEditingController sUPhoneTextEditingController = TextEditingController();
  TextEditingController sUPasswordTextEditingController =
      TextEditingController();
  User? cUser;

  signUpValidateForm(BuildContext context) {
    if (sUNameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 Characters.");
    } else if (!sUEmailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (sUPhoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number is required.");
    } else if (sUPasswordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    } else {
      saveUserInfoNow(context);
    }
    notifyListeners();
  }

  saveUserInfoNow(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    try {
      final cUser = (await fAuth.createUserWithEmailAndPassword(
        email: sUEmailTextEditingController.text.trim(),
        password: sUPasswordTextEditingController.text.trim(),
      ))
          .user;

      if (cUser != null) {
        FirebaseFirestore.instance.collection("users").doc(cUser.uid).set({
          "id": cUser.uid,
          "name": sUNameTextEditingController.text.trim(),
          "email": sUEmailTextEditingController.text.trim(),
          "phone": sUPhoneTextEditingController.text.trim(),
        });

        currentFirebaseUser = cUser;
        Fluttertoast.showToast(msg: "Account has been Created.");
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Account has not been Created.");
      }
    } catch (error) {
      log("Error: $error");
      Fluttertoast.showToast(msg: "Error: $error");
    }
    notifyListeners();
  }

  validateForm(BuildContext context) {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginUserNow(context);
    }
    notifyListeners();
  }

  loginUserNow(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return const ProgressDialog(
            message: "Processing, Please wait...",
          );
        });
    try {
      final User? firebaseUser = (await fAuth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ))
          .user;
      if (firebaseUser != null) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersCollection = firestore.collection('users');

        usersCollection.doc(firebaseUser.uid).get().then((userDoc) {
          if (userDoc.exists) {
            currentFirebaseUser = firebaseUser;
            Fluttertoast.showToast(msg: "Login Successful.");
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()));
          } else {
            Fluttertoast.showToast(msg: "No record exists with this email.");
            FirebaseAuth.instance.signOut();
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()));
          }
        });
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error Occurred during Login.");
      }
    } catch (msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: $msg");
    }
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then(
          (value) => Navigator.of(context)
              .pushReplacementNamed(MySplashScreen.routeName),
        );
  }
}
