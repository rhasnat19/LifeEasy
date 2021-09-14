// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_final_fields, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:life_easy/models/httpException.dart';
import 'package:life_easy/providers/auth_provider.dart';
import 'package:life_easy/screens/bottom_nav_bar.dart';
import 'package:life_easy/screens/home_screen.dart';
import 'package:life_easy/screens/otp_screen.dart';
import 'package:life_easy/widgets/logo_widget.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

enum AuthMode { Signup, Login }

class Authentication extends StatefulWidget {
  static const routeName = 'auth-screen';
  Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController drivingLincenseController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    if (nameController.text.trim() != null ||
        phoneController.text.trim() != null ||
        drivingLincenseController.text.trim() != null ||
        emailController.text.trim() != null ||
        passwordController.text.trim() != null) {
      setState(() {
        _isButtonEnabled = true;
      });
    } else {
      _isButtonEnabled = false;
    }
  }

  bool _isLoading = false;
  Map<String, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
    'phoneNumber': '',
    'drivingLicense': '',
  };

  void _showErrorDialog(String mess) {
    showDialog<Null>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occured'),
        content: Text(mess),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Okay'),
          ),
        ],
      ),
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _formKey.currentState!.reset();

        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _formKey.currentState!.reset();

        _authMode = AuthMode.Login;
      });
    }
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = false;
    });
    try {
      if (_authMode == AuthMode.Login) {
        Provider.of<Auth>(context, listen: false)
            .signin(
                _authData['email'].toString(), _authData['password'].toString())
            .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
                MyBottomNavigation.routeName, (Route<dynamic> route) => false));
      } else {
        Provider.of<Auth>(context, listen: false)
            .signup(
              email: _authData['email'].toString(),
              password: _authData['password'].toString(),
              drivingLicense: _authData['drivingLicense'].toString(),
              name: _authData['name'].toString(),
              phoneNumber: _authData['phoneNumber'].toString(),
            )
            .then(
              (value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) =>
                        OTPGenerator(phoneNumber: _authData['phoneNumber'])),
              ),
            );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      var errorMess = 'Could not authenticate you.';
      _showErrorDialog(errorMess);
    }

    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: LogoWidget(),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        if (_authMode == AuthMode.Signup)
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmptyOrNull) {
                                  return 'Enter Name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _authData['email'] = value.toString();
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white38,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 0.0,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: 'Name',
                                errorStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        if (_authMode == AuthMode.Signup)
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: drivingLincenseController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white38,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 0.0,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: 'Driving License',
                                errorStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              validator: (value) {
                                if (value.isEmptyOrNull) {
                                  return 'Enter Driving License';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _authData['drivingLicense'] = value.toString();
                              },
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white38,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0.0,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'Email',
                              errorStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmptyOrNull || !value!.contains('@')) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              _authData['email'] = value.toString();
                            },
                          ),
                        ),
                        if (_authMode == AuthMode.Signup)
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: phoneController,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white38,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 0.0,
                                  ),
                                ),
                                labelStyle: TextStyle(color: Colors.white),
                                labelText: 'Mobile Number (+920000000000)',
                                errorStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.contains(RegExp(r'[A-Za-z]')) ||
                                    !value.startsWith('+92')) {
                                  return 'Must start with +92';
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                _authData['phoneNumber'] = value.toString();
                              },
                            ),
                          ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            controller: passwordController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white38,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0.0,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              labelText: 'Password',
                              errorStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 8) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value.toString();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            margin: _authMode == AuthMode.Signup
                                ? EdgeInsets.only(top: 10)
                                : EdgeInsets.only(top: 0),
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    autofocus: false,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        _authMode == AuthMode.Login
                                            ? Colors.blue
                                            : Colors.red,
                                      ),
                                    ),
                                    //color: Colors.blueGrey[200],
                                    child: Text(
                                      _authMode == AuthMode.Login
                                          ? 'Login'
                                          : 'Generate OTP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontFamily: 'PlayfairDisplay',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: _signup,

                                    // _authMode == AuthMode.Login
                                    //     ? print('Login')
                                    //     : _signup;
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Text(
                                      _authMode == AuthMode.Login
                                          ? 'Does not have an account? '
                                          : 'Already have an account?',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontFamily: 'SF Pro Display Light'),
                                    ),
                                    TextButton(
                                      child: Text(
                                        _authMode == AuthMode.Login
                                            ? 'Register now'
                                            : 'Login Now',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'PlayfairDisplay',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amberAccent,
                                        ),
                                      ),
                                      onPressed: _switchAuthMode,
                                    ),
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
            .pOnly(left: 5, top: 10, right: 5, bottom: 10)
            .centered()
            .h(
              MediaQuery.of(context).size.height,
            )
            .w(
              MediaQuery.of(context).size.width,
            )
            .backgroundColor(
              Colors.black,
            ),
      ),
    );
  }
}
