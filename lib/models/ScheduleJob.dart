import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleJob {
  final String id;
  final String title;
  final int interval;
  final int lastCompleted;
  final int dueAt;
  final bool isDue = false;
  final String vehicleId;

  const ScheduleJob({required this.id, required this.title, required this.interval, required this.lastCompleted, required this.dueAt, required this.vehicleId});

  factory ScheduleJob.fromMap(DocumentSnapshot doc) {
    return ScheduleJob(
      id: doc.id, 
      title: doc['title'], 
      interval: doc['interval'], 
      lastCompleted: doc['lastCompleted'], 
      dueAt: doc['dueAt'],
      vehicleId: (doc['vehicleId'] is DocumentReference)
        ? (doc['vehicleId'] as DocumentReference).id // Extract the ID from DocumentReference
        : doc['vehicleId']
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'interval': interval,
      'lastCompleted': lastCompleted,
      'dueAt': dueAt,
      'isDue': isDue,
      'vehicleId': vehicleId
    };
  }
}