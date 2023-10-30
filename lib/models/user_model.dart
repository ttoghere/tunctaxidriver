// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;
  UserModel({
    this.phone,
    this.name,
    this.id,
    this.email,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      phone: data['phone'],
      name: data['name'],
      id: data["id"],
      email: data['email'],
    );
  }
}
