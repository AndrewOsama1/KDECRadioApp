import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  late String uid;
  late String email;
  late String name;
  late String phone;
  late int age;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
    required this.age,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'age': age,
    };
  }

  UserModel.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      email = json['email'].toString();
      name = json['name'].toString();
      phone = json['phone'].toString();

      age = int.parse(json['age'].toString());
    } else {
      // Handle null JSON data or initialize default values if needed
      email = '';
      name = '';
      phone = '';

      age = 0;
    }
  }
  void setUser(UserModel model) {
    uid = model.uid;
    email = model.email;
    name = model.name;
    phone = model.phone;
    age = model.age;

    notifyListeners();
  }
}
