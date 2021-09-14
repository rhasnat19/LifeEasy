// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:life_easy/screens/service_selected_screen.dart';

class ServicesCard extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String name;
  const ServicesCard({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //   final services = Provider.of<Services>(context, listen: false);
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Card(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ServicesDetailScreen.routeName,
                arguments: id,
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: 120,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black45,
                    ),
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
