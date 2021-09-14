import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String drivingLicense;
  final String mobileNumber;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.drivingLicense,
    required this.mobileNumber,
  });
}
