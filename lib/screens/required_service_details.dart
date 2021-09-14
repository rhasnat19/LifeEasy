// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class RequiredServiceDetail extends StatefulWidget {
  static const routeName = 'required-screen';
  RequiredServiceDetail({Key? key}) : super(key: key);

  @override
  _RequiredServiceDetailState createState() => _RequiredServiceDetailState();
}

class _RequiredServiceDetailState extends State<RequiredServiceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Required Service Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView(
                children: [
                  Text('Dummy Item A(Fixed)     -1+     [Amount]'),
                  Text('Dummy Item B(Fixed)     -1+     [Amount]'),
                  Text('Dummy Item C(Fixed)     -1+     [Amount]'),
                  Text('Dummy Item D(Fixed)     -1+     [Amount]'),
                  Text('Add Mode Services'),
                  Text('Total Item(5)     Total Quantity    Total Amount'),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text('Pie Chart')
            ],
          ),
        ),
      ),
    );
  }
}
