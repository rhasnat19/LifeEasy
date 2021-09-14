// ignore_for_file: unused_field, prefer_final_fields, file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:life_easy/models/services.dart';

class ServicesProvider with ChangeNotifier {
  List<Services> _services = [
    Services(
      id: 's1',
      name: 'Service A',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/4/41/Sunflower_from_Silesia2.jpg',
    ),
    Services(
      id: 's2',
      name: 'Service B',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/4/41/Sunflower_from_Silesia2.jpg',
    ),
    Services(
      id: 's3',
      name: 'Service C',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/4/41/Sunflower_from_Silesia2.jpg',
    ),
    Services(
      id: 's4',
      name: 'Service D',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/4/41/Sunflower_from_Silesia2.jpg',
    ),
  ];

  List<Services> get services {
    return [..._services];
  }

  Services findById(String id) {
    return _services.firstWhere((serv) => serv.id == id);
  }

  Future<void> fetchAndSetServices() async {
    try {
      final List<Services> loadedProduct = [];

      final url = Uri.parse(
        'https://lifeeasy-hasnat-default-rtdb.firebaseio.com/services.json',
      );
      final response = await http.get(url);
      final fetchData = json.decode(response.body);
      fetchData.forEach((serviceID, serviceData) {
        loadedProduct.add(Services(
          id: serviceID,
          name: serviceData['name'],
          imageUrl: serviceData['imageUrl'],
        ));
      });
      _services.addAll(loadedProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addServices(Services services) async {
    final url = Uri.parse(
        'https://lifeeasy-hasnat-default-rtdb.firebaseio.com/services.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': services.name,
            'imageUrl': services.imageUrl,
            //'isFavorite': product.isFavorite,
          },
        ),
      );
      final newService = Services(
        id: json.decode(response.body)['name'],
        name: services.name,
        imageUrl: services.imageUrl,
      );
      _services.add(newService);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
