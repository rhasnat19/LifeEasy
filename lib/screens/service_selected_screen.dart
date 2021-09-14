// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields

import 'dart:async';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:life_easy/screens/googleMap.dart';
import 'package:provider/provider.dart';
import 'package:life_easy/providers/servicesProvider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:life_easy/screens/required_service_details.dart';

class ServicesDetailScreen extends StatefulWidget {
  static const routeName = 'services-details';
  const ServicesDetailScreen({Key? key}) : super(key: key);

  @override
  State<ServicesDetailScreen> createState() => _ServicesDetailScreenState();
}

class _ServicesDetailScreenState extends State<ServicesDetailScreen> {
  String locationMessage = '';

  late final CameraPosition currentPosition;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _karachi = CameraPosition(
    target: LatLng(66.990501, 24.860966),
    zoom: 14.4746,
  );

  void _getUserLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var latPosition = await Geolocator.getLastKnownPosition();

    var addresses =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      locationMessage = addresses.first.street.toString() +
          ', ' +
          addresses.first.locality.toString();
      currentPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        bearing: 192.8334901395799,
        tilt: 59.440717697143555,
        zoom: 19.151926040649414,
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final serviceId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedService = Provider.of<ServicesProvider>(context, listen: false)
        .findById(serviceId);
    final dateformat = DateFormat("dd-MM-yyyy");
    final timeformat = DateFormat("HH:mm");

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedService.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Center(
                        child: Text(
                          'When the service is required : ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: DateTimeField(
                          format: dateformat,
                          onShowPicker: (context, currentVal) {
                            return showDatePicker(
                                context: context,
                                initialDate: currentVal ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                          }),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Center(
                        child: Text(
                          'Service Required at time : ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 20),
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: DateTimeField(
                        format: timeformat,
                        onShowPicker: (context, currentValue) async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.convert(time);
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Location: '),
                  Container(
                    child: Text(locationMessage),
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Estimated Duration: '),
                  Text('Hours/Days'),
                ],
              ),
              SizedBox(
                height: 80,
              ),
              Column(
                children: [
                  Text('Geo Tagging'),
                  Text('Geo Tag Button'),
                  Container(
                    padding: EdgeInsets.all(10),
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      mapType: MapType.hybrid,
                      initialCameraPosition: _karachi,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(RequiredServiceDetail.routeName);
                },
                child: Text('Final Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
