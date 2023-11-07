import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tunctaxidriver/repositories/request_assistant.dart';
import 'package:tunctaxidriver/global/global.dart';
import 'package:tunctaxidriver/controllers/app_info.dart';
import 'package:tunctaxidriver/models/directions.dart';
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

  static Future<String> searchAddressForGeographicCoordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      try {
        Map<String, dynamic> responseData =
            requestResponse as Map<String, dynamic>;

        if (responseData.containsKey("results") &&
            responseData["results"] is List &&
            responseData["results"].isNotEmpty) {
          humanReadableAddress =
              responseData["results"][0]["formatted_address"] as String;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Adres: $humanReadableAddress")));

          Directions userPickUpAddress = Directions();
          userPickUpAddress.locationLatitude = position.latitude;
          userPickUpAddress.locationLongitude = position.longitude;
          userPickUpAddress.locationName = humanReadableAddress;

          Provider.of<AppInfo>(context, listen: false)
              .updatePickUpLocationAddress(userPickUpAddress);
        } else {
          log("Sonuçlar boş veya eksik.");
        }
      } catch (error) {
        log("Hata oluştu: $error");
      }
    } else {
      log("İstek hatalı.");
    }
    return humanReadableAddress;
  }
}
