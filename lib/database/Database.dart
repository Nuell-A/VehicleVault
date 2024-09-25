import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:maintenance_tracker/models/History.dart';
import 'package:maintenance_tracker/models/Vehicle.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection for history, vehicles, and schedule.
  CollectionReference get historyCollection => _firestore.collection('history');
  CollectionReference get vehiclesCollection => _firestore.collection('vehicles');
  CollectionReference get schedulesCollection => _firestore.collection('schedules');

  // Add a vehicle
  Future<void> addVehicle({
    required String vehicleName,
    required int year,
    required int miles,
    required String description
  }) async {
    await vehiclesCollection.add({
      'vehicleName': vehicleName,
      'year': year,
      'miles': miles,
      'description': description
    });
  }

  // Add history record
  Future<void> addHistory(String vehicelId, {
    required String jobTitle,
    required DateTime date,
    required int miles,
    required String jobDescription
  }) async {
    // Get vehicle reference
    DocumentReference vehicleRef = vehiclesCollection.doc(vehicelId);

    // Add history record.
    await historyCollection.add({
      'jobTitle': jobTitle,
      'date': date,
      'miles': miles,
      'jobDescription': jobDescription,
      'vehicleId': vehicleRef
    });
  }

  // Get vehicles stream
  Stream<List<Vehicle>> getVehiclesStream() {
    return vehiclesCollection.snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Vehicle.fromMap(doc)).toList();
      },
    );
  }
  
  // Get history stream
  Stream<List<History>> getHistoryStream(String vehicleId) {
    // Find vehicle document
    final vehicleRef = vehiclesCollection.doc(vehicleId); // Get referenced document.
    
    // Return query from History where vehicle ID matches the reference found.
    return historyCollection.where('vehicleId', isEqualTo: vehicleRef).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => History.fromMap(doc)).toList();
      }
    );
  }

  // Find specific vehicle
  Future<Vehicle> findVehicle(String vehicelId) async {
    QuerySnapshot snapshot = await vehiclesCollection.get();
    List<Vehicle> vehicles = snapshot.docs.map((doc) => Vehicle.fromMap(doc)).toList();
    return vehicles.where((vehicle) => vehicle.id == vehicelId).first;
  }
}