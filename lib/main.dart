// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:life_easy/providers/auth_provider.dart';
import 'package:life_easy/providers/servicesProvider.dart';
import 'package:life_easy/screens/add_new_service.dart';
import 'package:life_easy/screens/auth_screen.dart';
import 'package:life_easy/screens/bottom_nav_bar.dart';
import 'package:life_easy/screens/googleMap.dart';
import 'package:life_easy/screens/home_screen.dart';
import 'package:life_easy/screens/otp_screen.dart';
import 'package:life_easy/screens/required_service_details.dart';
import 'package:life_easy/screens/service_selected_screen.dart';
import 'package:life_easy/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: ServicesProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: {
          Authentication.routeName: (ctx) => Authentication(),
          OTPGenerator.routeName: (ctx) => OTPGenerator(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          ServicesDetailScreen.routeName: (ctx) => ServicesDetailScreen(),
          MyBottomNavigation.routeName: (ctx) => MyBottomNavigation(
                title: '',
              ),
          RequiredServiceDetail.routeName: (ctx) => RequiredServiceDetail(),
          AddNewService.routeName: (ctx) => AddNewService(),
        },
      ),
    );
  }
}
