import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String vehicleName;
  final int year;
  final int miles;
  final String description;

  Vehicle({required this.id, required this.vehicleName, required this.year, required this.miles, required this.description});

  factory Vehicle.fromMap(DocumentSnapshot doc) {
    return Vehicle(
      id: doc.id,
      vehicleName: doc['vehicleName'],
      year: doc['year'],
      miles: doc['miles'],
      description: doc['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "vehicleName": vehicleName,
      "year": year,
      "miles": miles,
      "description": description
    };
  }
}