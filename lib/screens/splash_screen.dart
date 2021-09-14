// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:life_easy/screens/auth_screen.dart';
import 'package:life_easy/widgets/logo_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class SplashScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void showRelevant() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return Authentication();
      }),
    );
  }

  @override
  void initState() {
    showRelevant();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        // padding:
        //     EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.09),
        child: LogoWidget(),
      ),
    );
  }
}
