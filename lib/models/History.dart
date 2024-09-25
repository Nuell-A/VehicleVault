import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  final String id;
  final String jobTitle;
  final DateTime date;
  final int miles;
  final String jobDescription;
  final String vehicleId;

  History({required this.id, required this.jobTitle, required this.date, required this.miles, required this.jobDescription, required this.vehicleId});

  factory History.fromMap(DocumentSnapshot doc) {
    return History(
      id: doc.id,
      jobTitle: doc['jobTitle'],
      date: (doc['date'] as Timestamp).toDate(),
      miles: doc['miles'],
      jobDescription: doc['jobDescription'],
      vehicleId: (doc['vehicleId'] is DocumentReference)
        ? (doc['vehicleId'] as DocumentReference).id // Extract the ID from DocumentReference
        : doc['vehicleId'] // If it's a string already, use it directly
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "jobTitle": jobTitle,
      "date": date,
      "miles": miles,
      "jobDescription": jobDescription,
      "vehicleId": vehicleId
    };
  }
}