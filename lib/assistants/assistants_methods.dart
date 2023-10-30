import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tunctaxidriver/global/global.dart';
import 'package:tunctaxidriver/models/user_model.dart';

class AssistantMethods {
  static Future<void> readCurrentOnlineUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef =
        firestore.collection('users').doc(currentFirebaseUser!.uid);

    DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      userModelCurrentInfo = UserModel.fromSnapshot(userSnapshot);
      log("Name: ${userModelCurrentInfo!.name}");
      log("Name: ${userModelCurrentInfo!.email}");
    }
  }
}
