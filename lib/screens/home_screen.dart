// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:life_easy/models/services.dart';
import 'package:life_easy/providers/servicesProvider.dart';
import 'package:life_easy/screens/add_new_service.dart';
import 'package:life_easy/screens/service_selected_screen.dart';
import 'package:life_easy/widgets/logo_widget.dart';
import 'package:life_easy/widgets/service_card.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _refreshServices(BuildContext context) async {
    await Provider.of<ServicesProvider>(context, listen: false)
        .fetchAndSetServices();
  }

  @override
  Widget build(BuildContext context) {
    //final servicesData = Provider.of<ServicesProvider>(context);
    //  final services = servicesData.services;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Life Easy App',
          ).pOnly(right: MediaQuery.of(context).size.width * 0.15),
        ),
        leading: Builder(builder: (context) {
          return Text(
            'Logo ',
            style: TextStyle(
              fontSize: 20,
            ),
          ).pOnly(left: MediaQuery.of(context).size.width * 0.05).centered();
        }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Center(
                  child: Text('Select Service',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )).centered(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 480,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20)),
                  child: FutureBuilder(
                    future: _refreshServices(context),
                    builder: (ctx, snapShot) => Consumer<ServicesProvider>(
                      builder: (ctx, servicesData, _) => GridView.builder(
                        itemCount: servicesData.services.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 4 / 1.8,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 3,
                        ),
                        itemBuilder: (ctx, i) => Column(
                          children: [
                            ServicesCard(
                              id: servicesData.services[i].id,
                              name: servicesData.services[i].name,
                              imageUrl: servicesData.services[i].imageUrl,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Want to add a new service?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AddNewService.routeName);
                        },
                        child: Text(
                          'Tap here.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[400],
                          ),
                        ))
                  ],
                ),
              ),
              //  SizedBox(height: 600, child: ServicesDetailScreen()),
            ],
          ),
        ),
      ),
      //.centered().pOnly(left: 5, top: 10, right: 5, bottom: 10),
    );
  }
}

class SericesWidgets extends StatelessWidget {
  const SericesWidgets({
    Key? key,
    required this.services,
  }) : super(key: key);

  final List<Services> services;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
