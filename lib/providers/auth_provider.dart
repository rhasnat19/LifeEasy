// ignore_for_file: prefer_final_fields, avoid_print, unnecessary_new

import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:life_easy/models/httpException.dart';
import 'package:life_easy/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;
  List<User> _user = [];
  // late Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        ('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA3_zqqCnhYaKXOR-wTA9ItipFShNsPbwM'));
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      // _autoLogout();
      notifyListeners();
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode(
      //   {
      //     'token': _token,
      //     'userId': _userId,
      //     'expiryDate': _expiryDate.toIso8601String(),
      //   },
      // );
      // prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String name,
    required String drivingLicense,
    required String phoneNumber,
  }) async {
    User user = new User(
      name: name,
      email: email,
      mobileNumber: phoneNumber,
      drivingLicense: drivingLicense,
      id: DateTime.now().toString(),
      password: '',
    );
    return _authenticate(email, password, 'signUp').then((_) => addUser(user));
  }

  Future<void> addUser(User user) async {
    final url = Uri.parse(
        'https://lifeeasy-hasnat-default-rtdb.firebaseio.com/user.json');
    // final url =
    //     'https://shopapp-b6357-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'phoneNumber': user.mobileNumber,
            'driver_license': user.drivingLicense,

            //'isFavorite': product.isFavorite,
          },
        ),
      );
      final newUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        password: user.password,
        drivingLicense: user.drivingLicense,
        mobileNumber: user.mobileNumber,
      );
      _user.add(newUser);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (!prefs.containsKey('userData')) {
  //     return false;
  //   }
  //   final extractedUserData =
  //       json.decode(prefs.getString('userData')) as Map<String, Object>;
  //   final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

  //   if (expiryDate.isBefore(DateTime.now())) {
  //     return false;
  //   }
  //   _token = extractedUserData['token'];
  //   _userId = extractedUserData['userId'];
  //   _expiryDate = expiryDate;
  //   notifyListeners();
  //   _autoLogout();
  //   return true;
  // }

  // void logout() async {
  //   _token = null;
  //   _userId = null;
  //   _expiryDate = null;
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //     _authTimer = null;
  //   }
  //   notifyListeners();
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }

  // void _autoLogout() {
  //   if (_authTimer != null) {
  //     _authTimer.cancel();
  //   }
  //   final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  // }
}
